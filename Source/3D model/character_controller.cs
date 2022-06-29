using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LanceCommon : MonoBehaviour
{
    public Animator animator;
    private GameObject Controller;
    public GameObject Target;

    private Parameter CallParameter;            // Inherit the parameters
    private Ability CallAbilities;              // Call the method of abilities

    // Declear the parameters
    private float WalkSpeed;
    private float WalkRotate;
    private float BoostSpeed;
    private float GyratoryPerformance;
    private AnimationCurve BoostRotate;
    private float StepSpeed;
    private AnimationCurve StepAcceleration;
    private AnimationCurve ControllerRotationSpeed;


    void Start()
    {
        animator = GetComponent<Animator>();
        Controller = GameObject.FindGameObjectWithTag("Controller1");
        Target = GameObject.FindGameObjectWithTag("Enemy1");

        // Access to another script attached to this object
        CallParameter = this.GetComponent<Parameter>();
        CallAbilities = this.GetComponent<Ability>();

        // Inherit the parameters
        WalkSpeed = CallParameter.WalkSpeed;
        WalkRotate = CallParameter.WalkRotate;
        BoostSpeed = CallParameter.BoostSpeed;
        GyratoryPerformance = CallParameter.GyratoryPerformance;
        BoostRotate = CallParameter.BoostRotate;
        StepSpeed = CallParameter.StepSpeed;
        StepAcceleration = CallParameter.StepAcceleration;
        ControllerRotationSpeed = CallParameter.ControllerRotationSpeed;
    }


    Transform ThisTrans;                           // Declare to cache this.transform
    Transform ControllerTrans;
    Transform TargetTrans;

    // Parameters
    private float DeltaTime;
    // input direction
    public float xAxis;                            // Horizontal input
    public float yAxis;                            // Vertical input
    private bool ButtonUp;                         // Judge the start of pushing the direction to avoid duplicate walk and step flag
    // previous and current state
    //private string CurrentState;
    private float Status;                          // the animation of the previous frame
    private float NextStatus = 0.0f;               // the animation of the current frame
    // judge landing
    private bool Landing;
    // Measure BD time
    private float DashTime;
    // judge stepping
    private bool FrontStepFlag;                    // Now Stepping toward for front
    private bool BackStepFlag;                     // Now Stepping toward for back
    private bool LeftStepFlag;                     // Now Stepping toward for left
    private bool RightStepFlag;                    // Now Stepping toward for right
    private bool Stepping;                         // Now Stepping
    // judge enable to step
    private bool StepFlag;
    private float StepReceptionTime = 0.4f;        // Accepts step from the beginning of the walking to 0.8s
    private float StepReceptionCount = 0.0f;       // Count the time since start entering the direction
    private float PreviousHorizontal;
    private float PreviousVertical;
    // judge enable to walk
    private bool Walking;
    private bool Idling;
    private bool Walkable;
    // stepping time
    private float StepTime = 0.0f;                 // Count the time since start stepping
    private float Length = 0f;
    // amount move
    private Vector3 AmoundOfMovement;
    private Vector3 StepMovement;
    // Parameters that define the X-Z plane based on thedirection of the camera
    private Vector3 cameraForward;
    private Vector3 moveForward;
    private Vector3 MoveStep;
    // Parameters related to the angle of the internal controller
    private float RotationTimeCount;

    private Vector3 Angle = new Vector3(1f, 0f, 1f);  // カメラのアングルなので必要無くなれば削除


    void Update()
    {
        ThisTrans = this.transform;                    // Define to cache this.transform
        ControllerTrans = Controller.transform;
        DeltaTime = Time.deltaTime;

        xAxis = Input.GetAxisRaw("Horizontal");        // x-xis input
        yAxis = Input.GetAxisRaw("Vertical");          // y-axis input

        DefineXZPlane();
        if ((xAxis != 0f) || (yAxis != 0f))
        {
            ControllerRotate();
        }
        else
        {
            RotationTimeCount = 0f;
        }

        // CurrentState = animator.GetCurrentAnimatorClipInfo(0)[0].clip.name;
        

        // judge stepping
        // purpose: change the rotation specifications, and do not accept walking while stepping
        FrontStepFlag = animator.GetCurrentAnimatorStateInfo(0).IsName("Lance_FrontStep");
        BackStepFlag = animator.GetCurrentAnimatorStateInfo(0).IsName("Lance_BackStep");
        LeftStepFlag = animator.GetCurrentAnimatorStateInfo(0).IsName("Lance_LeftStep");
        RightStepFlag = animator.GetCurrentAnimatorStateInfo(0).IsName("Lance_RightStep");
        Stepping = (FrontStepFlag || BackStepFlag || LeftStepFlag || RightStepFlag);

        // Step
        StepFlag = false;                // Flag initialization
        if (((yAxis != 0f) || (xAxis != 0f)) && (StepReceptionCount < StepReceptionTime))       // after StepReceptionTime, not measure because it is useless
        {
            ReceptionTime();             // Measure the time while inputting the direction. Accept step only a certain period of time
        }
        if ((0f < StepReceptionCount) && (StepReceptionCount <= StepReceptionTime))
        {
            StepFlag = true;             // accepts step input for StepReceptionTime[sec] from inputting direction
        }

        if ((!Stepping) && (StepFlag) && ((yAxis == 0f) && (xAxis == 0f)) && ((PreviousHorizontal != 0f) || (PreviousVertical != 0f)))
        {
            StepTime = 0f;
            StepTranslate();             // Call in advance for the first lap of stepping
            SteppngTime();               // Call in advance for the first lap of stepping
            StepAnimation();             // Step starts when the StepFlag is true and the finger is released
        }
        if ((Input.GetButtonUp("Horizontal") && (yAxis == 0f)) || (Input.GetButtonUp("Vertical") && (xAxis == 0f)))
        {
            StepReceptionCount = 0.0f;   // Initialize when finger is released
        }

        Landing = animator.GetCurrentAnimatorStateInfo(0).IsName("Lance_Landing");
        Status = animator.GetFloat("MoveSpeed");

        Walking = animator.GetCurrentAnimatorStateInfo(0).IsName("Lance_Walk");
        Idling = animator.GetCurrentAnimatorStateInfo(0).IsName("Lance_Wait");
        Walkable = (Walking || Idling);

        // Idleing
        if (((yAxis == 0f) || (xAxis == 0f)) && (0f <= Status) && (Status < 2f))     // Idling if no direction input and idling or walking in the previous frame
        {
            NextStatus = Idle();
        }

        // Walk
        ButtonUp = (Input.GetButtonUp("Horizontal") || Input.GetButtonUp("Vertical"));
        if (((yAxis != 0f) || (xAxis != 0f)) && (0f <= Status) && (Status < 2f) && !ButtonUp && Walkable)
        {    // Idling if direction input and idling or walking in the previous frame
            NextStatus = Walk();
        }

        // BD, Landing
        if (Input.GetKeyDown(KeyCode.LeftShift)){                     // Translate to BD by inputting LeftShit, and translate to landing by inputting LeftShift during BD
            
            NextStatus = Boost(Status);
        }
        if (Status < 0f)                                              // Initialize an animator parameter if the object landed in previous frame and play end in the current frame
        {
            FlagInitialize();                                         // -2 to 0
        }
        if(Status < 2f)
        {
            DashTime = 0f;
        }
        if ((1f < NextStatus) && !Stepping)                           // Set mobility if BD or walking
        {
            MobilityRotate(NextStatus);
            MobilityMove(NextStatus);
        }

        // Call Ability
        if (Input.GetKeyDown(KeyCode.Keypad1))                        // Call Ability 1
        {
            CallAbilities.Ability1();
        }
        else if (Input.GetKeyDown(KeyCode.Keypad2))                   // Call Ability 2
        {
            CallAbilities.Ability2();
        }
        else if (Input.GetKeyDown(KeyCode.Keypad3))                   // Call Ability 3
        {
            CallAbilities.Ability3();
        }

        if (Stepping)
        {
            StepTranslate();                      // translate during stepping
            SteppngTime();
        }

        // memorize the direction input of 1 frame before
        PreviousHorizontal = xAxis;
        PreviousVertical = yAxis;
    }



    private float IdleParameter = 0.5f;
    private float WalkParameter = 1.5f;
    private float BoostParameter = 3f;
    private float LandingParameter = -2f;

    void DefineXZPlane()
    {
        // Define the X-Z plane from the direction of the main camera: get the unit vector of the X-Z plane
        cameraForward = Vector3.Scale(Camera.main.transform.forward, Angle);
        // Determine the moving direction from the input value of the direction key and the direction of the caamera
        moveForward = cameraForward * yAxis + Camera.main.transform.right * xAxis;
    }
    void ControllerRotate()
    {
        RotationTimeCount += DeltaTime;

        Quaternion rot = Quaternion.LookRotation(moveForward);                   // Final Angle
        rot = Quaternion.Slerp(ThisTrans.rotation, rot, ControllerRotationSpeed.Evaluate(RotationTimeCount));
        ControllerTrans.rotation = rot;                                                // substitute angle to controller.rotation
    }

    // Look at target
    public void LookAt()
    {
        ThisTrans.LookAt(Target.transform);

        Vector3 WorldAngle = ThisTrans.eulerAngles;    // If the height of the enemy's gizmo is non-zero, rotation angle of this gizmo whill misalighn when using LookAt methid.
        WorldAngle.x = 0f;                             // At this time, if this object moves forward, it will float in the air or sink under the ground because the rotation misalighns.
        WorldAngle.z = 0f;
        ThisTrans.eulerAngles = WorldAngle;
    }

    // Initialize animation flag
    public void FlagInitialize()
    {
        animator.SetFloat("MoveSpeed", 0.0f);    // Initialize when landing or Stepping starts
    }

    // Idling
    float Idle()
    {
        animator.SetFloat("MoveSpeed", IdleParameter);      // Play Idling Animation
        return IdleParameter;                               // return current state
    }

    // Walk
    float Walk()
    {
        animator.SetFloat("MoveSpeed", WalkParameter);
        return WalkParameter;
    }

    // BD, Landing
    float Boost(float Flag)
    {
        if (Flag < 2f)            // If not BD, translate to BD
        {
            ThisTrans.rotation = ControllerTrans.rotation;
            animator.SetFloat("MoveSpeed", BoostParameter);
            return BoostParameter;
        }
        else                     // If BD, translate to Landing
        {
            animator.SetFloat("MoveSpeed", LandingParameter);
            return LandingParameter;
        }
    }

    // Mobility
    void MobilityRotate(float Flag)
    {
        // Contol of turning performance
        // When the movementis non-zero, change the direction of Controller
        if (moveForward != Vector3.zero)
        {
            // Set the turning performances to be difference for walking and BD
            Quaternion rot = Quaternion.LookRotation(moveForward);                   // Final Angle

            if (Flag < 2f)                                                           // Since the calling condition of Mobility is ≦1, Walking can be spevified only <2 condition
            {
                rot = Quaternion.Slerp(ThisTrans.rotation, rot, WalkRotate * DeltaTime);   // Complements the intermediate state of angle transition
            }
            else if (2f < Flag)
            {
                rot = Quaternion.Slerp(ThisTrans.rotation, rot, BoostRotate.Evaluate(DashTime)* GyratoryPerformance * DeltaTime);
            }
            ThisTrans.rotation = rot;                         // substitute angle to character.rotation
        }
    }
    void MobilityMove(float Flag)
    {
        if (Flag < 2f)
        {
            AmoundOfMovement = Vector3.forward * WalkSpeed;
        }
        else if (2f < Flag)
        {
            DashTime += DeltaTime;
            AmoundOfMovement = Vector3.forward * BoostSpeed;
        }
        ThisTrans.Translate(AmoundOfMovement * DeltaTime);                // substitute angle to character.position
    }


    //Step
    void ReceptionTime()
    {
        StepReceptionCount += DeltaTime;
    }
    void StepAnimation()
    {
        FlagInitialize();                                   // BD(etc.) is interrupted with the start of step
        LookAt();

        if (PreviousVertical >= 0.7f)                       // 1/sqrt(2): more than 45 degree
        {
            animator.SetTrigger("FrontStep");
        }
        else if(PreviousVertical <= -0.7f)
        {
            animator.SetTrigger("BackStep");
        }
        else if (PreviousHorizontal < -0.7)
        {
            animator.SetTrigger("LeftStep");
        }
        else if (PreviousHorizontal > 0.7)
        {
            animator.SetTrigger("RightStep");
        }
        StepMovement = new Vector3(PreviousHorizontal, 0.0f,PreviousVertical);
        StepMovement.Normalize();

        StartCoroutine(ReturnStepTime());
    }
    private IEnumerator ReturnStepTime()
    {
        // Immediately after start of the animation, the playback time connot be obtained correctly
        // use a coroutine method to obtain the playback time of the step after fer frames
        for (int i = 0; i < 3; i++)
        {
            yield return null;
        }
        // Reciprocal in advance to reduce the cost of division
        Length = 1 / animator.GetCurrentAnimatorStateInfo(0).length;
    }

    void StepTranslate()
    {
        ThisTrans.Translate(StepMovement * StepSpeed * StepAcceleration.Evaluate(StepTime * Length) * DeltaTime);
    }
    void SteppngTime()
    {
        StepTime += DeltaTime;
    }
}
