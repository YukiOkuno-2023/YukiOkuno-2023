using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using System.IO;
using System.Linq;

// A set value of the number of pixels of image must be a muptiply of a hundred.
// And Unit Per Pixels must be set (Xpixels/columns) = (Ypixels/rows).
// ex. image:600*800 Panel_X=3 ⇒ PanelSize=600/3=200=UnitPerPixels ⇒ PanelY=800/UnitPerPixels=800/200=4

public class Puzzle : MonoBehaviour
{
    public Text NumberText;
    const int Panel_X = 4;  // Number of Columns
    const int Panel_Y = 4;  // Number of Row
    float CameraDistance = System.Math.Max(Panel_X, Panel_Y);  // カメラとパズルの距離  3×3：3f、4×4：4f、5×5：5f
    public const int Amount_Panels = Panel_X * Panel_Y;

    int Panel_X_Size;
    int Panel_Y_Size;
    int[] Panel = new int[Amount_Panels];
    bool TimeFlag = false;
    float TimeCount = 0f;

    enum EState
    {
        TITLE,MAIN,CLEAR
    }
    EState State = EState.TITLE;   // First state is Title scene

    Sprite[] sprite;
    GameObject[] PanelObject;
    Vector3[] BasePosition;          // 初期状態を記憶しておく 比較することでクリアかどうかを判定
    private GameObject BackImage;
    private GameObject BackImage2;
    private GameObject StaticticsPr;

    // Start is called before the first frame update
    void Start()
    {
        StaticticsPr = GameObject.Find("Canvas2");
        StaticticsPr.SetActive(false);

        sprite = Resources.LoadAll<Sprite>("Panels/");
        GameObject obj = new GameObject();
        PanelObject = new GameObject[sprite.Length];
        BasePosition = new Vector3[sprite.Length];

        // 台紙のサイズ調整　3,4,5列のとき台紙のX座標は1,1.5,2、3,4,5行のとき台紙のY座標は-1,-1.5,-2
        BackImage = GameObject.Find("back");
        Transform BackTrans = BackImage.transform;
        Vector3 pos = BackTrans.position;
        float difX = Panel_X - 3f;
        float difY = Panel_Y - 3f;
        pos.x += 0.5f * difX;
        pos.y -= 0.5f * difY;
        BackTrans.position = pos;
        BackImage2 = GameObject.Find("back2");
        Transform BackTrans2 = BackImage2.transform;
        Vector3 pos2 = BackTrans2.position;
        float difX2 = Panel_X - 3f;
        float difY2 = Panel_Y - 3f;
        pos2.x += 0.5f * difX2;
        pos2.y -= 0.5f * difY2;
        BackTrans2.position = pos2;

        // カメラ位置をパネル枚数に応じて調節
        Camera.main.transform.position = new Vector3((Panel_X - 1f) / 2f, -(Panel_Y - 1f) / 2f, 0f);

        for (int i = 0; i < sprite.Length; ++i)
        {
            var position = Input.mousePosition;
            position.z = CameraDistance;
            position = Camera.main.ScreenToWorldPoint(position);

            PanelObject[i] = Instantiate(obj, new Vector3((i % Panel_X), -(i / Panel_X), position.z), Quaternion.identity) as GameObject;

            SpriteRenderer sr = PanelObject[i].AddComponent<SpriteRenderer>();
            // 生成したすべてのパネルにSpriteRendererコンポーネントを追加
            
            if(i < Amount_Panels - 1) {       // 3×3のパズルで表示するのは8までなので9の画像は入れないようにする
                sr.sprite = sprite[i];        // i番目にインスタンス化するゲームオブジェクトにロードしておいた画像の中のi番目の画像を入れる
            }

            PanelObject[i].AddComponent<BoxCollider2D>();

            PanelObject[i].name = i.ToString();
            PanelObject[i].tag = "Panel";

            BasePosition[i].x = PanelObject[i].transform.position.x;  // 初期位置を記憶しておく
            BasePosition[i].y = PanelObject[i].transform.position.y;
            BasePosition[i].z = position.z;
        }
        Destroy(obj);

        Panel_X_Size = Screen.width / Panel_X;
        Panel_Y_Size = Screen.width / Panel_Y;
    }

    void Change_Panels(int x,int y)
    {
        int P1 = y * Panel_X + x;   // 現在クリックしているパネルの番号
        // K[x,y]という二次元配列があった時、y * i * xとするとx, yの組み合わせで一意的な値になるので二次元配列を一次元配列に変換できる
        int P2 = -1;  // パネルの移動先 まだ確定していないので-1とする


        // パネルが12枚の時、0-11の番号で管理されており、11枚目は画面外に後で飛ばしている
        // パネル枚数-1番目であるということは左隣のパネルが空白であるということ

        // 左側に空白があれば左へ移動
        if(x > 0 && Panel[P1 - 1] == Amount_Panels - 1)
        {
            P2 = P1 - 1;
        }
        // 右に空白があれば右へ移動
        if(x < Panel_X - 1 && Panel[P1 + 1] == Amount_Panels - 1)
        {
            P2 = P1 + 1;
        }
        // 上に空白があれば上に移動
        if(y > 0 && Panel[P1 - Panel_X] == Amount_Panels - 1)
        {
            P2 = P1 - Panel_X;
        }

        // 下に空白があれば下に移動
        if(y < Panel_Y - 1 && Panel[P1 + Panel_X] == Amount_Panels - 1)
        {
            P2 = P1 + Panel_X;
        }

        // 移動処理
        if(P2 != -1)
        {
            Panel[P2] = Panel[P1];           // 移動
            Panel[P1] = Amount_Panels - 1;   // 元々の場所を空にする
        }

        for(int i = 0; i < Amount_Panels; i++)
        {
            if(Panel[i] < Amount_Panels - 1)
            {
                PanelObject[Panel[i]].transform.position = BasePosition[i];
                PanelObject[Panel[i]].name = i.ToString();
            }
            else
            {
                Vector2 temp = PanelObject[Panel[i]].transform.position;

                temp.y = 100f;              // 画面外にどかせる

                PanelObject[Panel[i]].transform.position = temp;
                PanelObject[Panel[i]].name = i.ToString();
            }
        }
    }


    // Update is called once per frame
    public List<float> historicalList;

    void Update()
    {
        if (TimeFlag)
        {
            TimeCount += Time.deltaTime;
        }

        switch (State)
        {
            case EState.TITLE: GameTitle(); break;
            case EState.MAIN: GameMain(); break;
            // case EState.CLEAR: GameClear();  break;    // 毎フレーム呼ぶとスコアの格納が重複するのでMAINから直接CLEARへ移動させる
        }


        if (Input.GetKeyDown(KeyCode.Q))     // グラフの表示
        {
            GetScore();
            historicalList = new List<float>(historicalData);  // グラフを実体化させる前に履歴をpublicで確保する

            StaticticsPr.SetActive(true);
        }
        if (Input.GetKeyDown(KeyCode.C))     // グラフ非表示
        {
            StaticticsPr.SetActive(false);
        }
    }


    void GameTitle()
    {
        if (Input.GetMouseButtonDown(0))
        {
            for(int i = 0; i < Amount_Panels; i++)
            {
                Panel[i] = i;       // 念のため初期化
            }

            for(int i = 0; i < Amount_Panels * 1000; i++)
            {
                Change_Panels(Random.Range(0, Panel_X), Random.Range(0, Panel_Y));   // ランダムにパネルを配置する
            }
            State = EState.MAIN;   // スタートからメインゲームへと状態を変遷

            NumberText.text = " ";
            TimeFlag = true;


            // 干支に対応した画像を表示する
            GameObject image = new GameObject("Image_Main");
            image.transform.parent = GameObject.Find("Canvas").transform;
            image.AddComponent<RectTransform>().anchoredPosition = new Vector3(400f, -120f, 0f);
            image.GetComponent<RectTransform>().localScale = new Vector3(1f, 1f, 1f);
            if(Amount_Panels % 12 == 9)
            {
                image.AddComponent<Image>().sprite = Resources.Load<Sprite>("monkey");
            }
            else if(Amount_Panels % 12 == 4){
                image.AddComponent<Image>().sprite = Resources.Load<Sprite>("rabbit");
            }
            else
            {
                // nothing
            }

            image.GetComponent<Image>().preserveAspect = true;
            image.GetComponent<Image>().SetNativeSize();
        }
    }

    // GameObject ClickGameObject;
    void GameMain()
    {
        Panel_X_Size = Screen.width / Panel_X;
        Panel_Y_Size = Screen.height / Panel_Y;

        int x = 0, y = 0;

        // GameMainは毎フレーム呼ばれるが、実行するのはクリックがした時のみ
        if (Input.GetMouseButtonDown(0))
        {
            var position = Input.mousePosition;
            position.z = CameraDistance;
            position = Camera.main.ScreenToWorldPoint(position);

            // クリックしたパネルのX座標を割り出す
            for(int i = 0; i <= Panel_X; i++)
            {
                if( ((i - 0.5f) < position.x) && (position.x < (i + 0.5f)) )
                {
                    x = i;
                }
            }
            // クリックしたパネルのY座標を割り出す
            for(int i = 0; i <= Panel_Y; i++)
            {
                if (((-i + 0.5f) > position.y) && (position.y > (-i - 0.5f)))
                {
                    y = i;
                }
            }

            // メモ：int.Part(文字列); とするとstring型の数字をintにすることが出来る

            Change_Panels(x, y);  // hitしたゲームオブジェクトを空白と交換させる


            // クリア判定
            bool ClearFlag = true;
            for(int i = 0; i < Amount_Panels; ++i)
            {
                if(Panel[i] != i)
                {
                    ClearFlag = false;
                    break;
                }
            }

            
            if(true)   // バグチェック
            //if (ClearFlag)
            {
                for (int i = 0; i < Amount_Panels - 1; ++i)   // 3×3のパズルなら表示したいのは1～8なので-1して9を非表示のままにする
                {
                    PanelObject[i].transform.position = BasePosition[i];
                }
                State = EState.CLEAR;
                GameClear();   // 終了後は何もしないのでUpdate内にする必要が無い

                // クリア画面を表示する
                GameObject Image = GameObject.Find("Image_Main");
                Destroy(Image);

                GameObject image = new GameObject("Image_Main");
                image.transform.parent = GameObject.Find("Canvas").transform;
                image.AddComponent<RectTransform>().anchoredPosition = new Vector3(0f, 23f, 0f);
                image.GetComponent<RectTransform>().localScale = new Vector3(1f, 1f, 1f);
                if (Amount_Panels % 12 == 9)
                {
                    image.AddComponent<Image>().sprite = Resources.Load<Sprite>("monkey2");
                }
                else if (Amount_Panels % 12 == 4)
                {
                    image.AddComponent<Image>().sprite = Resources.Load<Sprite>("rabbit2");
                }
                else
                {
                    // nothing
                }

                image.GetComponent<Image>().preserveAspect = true;
                image.GetComponent<Image>().SetNativeSize();
            }
        }
    }


    const int historyNum = 30;   // 履歴の件数
    [SerializeField, Header("履歴")]
    float[] historicalData = new float[historyNum];   // 0-4

    int[] history = Enumerable.Range(1, historyNum).ToArray();  // データのタグ

    void GameClear()
    {
        Debug.Log(TimeCount);
        TimeFlag = false;
        
        GetScore();
        SetScore();
    }

    void GetScore()
    {
        // クリアタイムの履歴を読み込む
        for (int i = 0; i < history.Length; i++)
        {
            historicalData[i] = PlayerPrefs.GetFloat(history[i].ToString());
        }
    }

    void SetScore()
    {
        // 現在保存されている履歴データの件数
        int ct = 0;
        for (int i = 0; i < historicalData.Length; i++)
        {
            if (historicalData[i] != 0)
            {
                ct += 1;
            }
        }

        // 履歴の件数が上限未満であれば後ろに追加
        if(ct < historyNum)
        {
            PlayerPrefs.SetFloat(history[ct].ToString(), TimeCount);
        }
        // 履歴の件数が上限なら1番目を削除して後ろに追加
        else
        {
            for(int i = 1; i < historyNum; i++)
            {
                PlayerPrefs.SetFloat(history[i-1].ToString(), historicalData[i]);
            }
            PlayerPrefs.SetFloat(history[historyNum-1].ToString(), TimeCount);
        }
    }
}
