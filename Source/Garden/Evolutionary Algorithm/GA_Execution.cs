using System.Collections;
using System.Collections.Generic;
using UnityEngine;

using System;
using System.IO;


public class GA_Execution : MonoBehaviour
{
    private GA_Parameters parameters;
    [SerializeField] private GameObject individualObject;
    private GA_Individuals individuals;
    public float[] scoreList;             // スコアリスト


    void Start()
    {
        parameters = this.GetComponent<GA_Parameters>();
        individuals = individualObject.GetComponent<GA_Individuals>();
        scoreList = new float[parameters.population];
    }


    private int currentGeneration = 1;
    public int elapse = 0;
    
    void LateUpdate()
    {
        if (elapse == parameters.timeLimit)
        {
            writeFile();

            var parents = SerectParents();                      // 最もスコアの高い個体と2番目に高い個体を返す
            NextGeneration(parents.Item1, parents.Item2);       // 交叉
            Mutation();                                         // 突然変異
            
            elapse = -1;
            currentGeneration++;
        }

        elapse++;
    }

    float distance = 0f;


    // スコア計算
    public float CalcScore(Vector3 pre, Vector3 now)
    {
        distance = Mathf.Sqrt(Mathf.Pow((pre.x - now.x), 2) + Mathf.Pow((pre.z - now.z), 2));
        // distance = now.x - pre.x;
        return distance;
    }


    // 前の世代の遺伝子を記録したファイルを削除し、更新する
    void writeFile()
    {
        File.Delete(parameters.path);

        for (int i = 0; i < parameters.population; i++)
        {
            for (int j = 0; j < 4 * parameters.joints.Length * parameters.steps + parameters.steps; j++)
            {
                using (var fs = new StreamWriter(parameters.path, true, System.Text.Encoding.GetEncoding("UTF-8")))
                {
                    fs.Write(parameters.genome[i, j] + "\n");
                }
            }
        }
    }


    // 両親のIDを返す
    (int, int) SerectParents()
    {
        float max1, max2, maxTemp;
        int index1, index2, indexTemp;

        max1 = scoreList[0];
        index1 = 0;

        // 最もスコアの高い個体を割り出す
        for(int i=1; i<parameters.population; i++)
        {
            if(max1 < scoreList[i])
            {
                max1 = scoreList[i];
                index1 = i;
            }
        }

        // 2番目にスコアが高い個体を割り出す
        if(index1 == 0)
        {
            max2 = scoreList[1];
            index2 = 1;
            for(int i=2; i<parameters.population; i++)
            {
                if(max2 < scoreList[i])
                {
                    max2 = scoreList[i];
                    index2 = i;
                }
            }
        }
        else if(index1 == parameters.population - 1)
        {
            max2 = scoreList[0];
            index2 = 0;
            for(int i=1; i<parameters.population-1; i++)
            {
                if(max2 < scoreList[i])
                {
                    max2 = scoreList[i];
                    index2 = i;
                }
            }
        }
        else
        {
            max2 = scoreList[0];
            index2 = 0;
            for(int i=1; i<index1; i++)
            {
                if(max2 < scoreList[i])
                {
                    max2 = scoreList[i];
                    index2 = i;
                }
            }
            maxTemp = scoreList[index1 + 1];
            indexTemp = index1 + 1;
            for(int i=index1+2; i<parameters.population; i++)
            {
                if(maxTemp < scoreList[i])
                {
                    maxTemp = scoreList[i];
                    indexTemp = i;
                }
            }
            if(max2 < maxTemp)
            {
                max2 = maxTemp;
                index2 = indexTemp;
            }
        }
        Debug.Log("第" + currentGeneration + "世代：" + max1 + " > " + max2);

        return (index1, index2);
    }


    private float[] parent1, parent2;

    void NextGeneration(int id1, int id2)
    {
        parent1 = new float[4 * parameters.joints.Length * parameters.steps + parameters.steps];
        parent2 = new float[parent1.Length];

        for (int i=0; i< 4 * parameters.joints.Length * parameters.steps + parameters.steps; i++)
        {
            parent1[i] = parameters.genome[id1, i];
            parent2[i] = parameters.genome[id2, i];
        }

        int geneMask;

        for (int i=0; i<parameters.population; i++)
        {
            for (int j=0; j<parent1.Length; j++)
            {
                geneMask = UnityEngine.Random.Range(0, 2);

                if (geneMask == 0)
                {
                    parameters.genome[i, j] = parent1[j];
                }
                else if (geneMask == 1)
                {
                    parameters.genome[i, j] = parent2[j];
                }
            }
        }
    }


    void Mutation()
    {
        int rand;

        for (int i = 0; i < parameters.population; i++)
        {
            // 関節に関する遺伝子の突然変異
            for (int j = 0; j <  parameters.steps; j++)
            {
                for (int k = 0; k < 4 * parameters.joints.Length; k++)
                {
                    rand = UnityEngine.Random.Range(0, parameters.mutationEvent + 1);
                    if (rand == 1)
                    {
                        if (k % 4 == 0) parameters.genome[i, j*4*parameters.joints.Length + k] = UnityEngine.Random.Range(
                            parameters.jointConfig[k + 0], parameters.jointConfig[k + 1]);

                        else if (k % 4 == 1) parameters.genome[i, j * 4 * parameters.joints.Length + k] = UnityEngine.Random.Range(
                            -1 * parameters.jointConfig[k + 1], parameters.jointConfig[k + 1]);

                        else if (k % 4 == 2) parameters.genome[i, j * 4 * parameters.joints.Length + k] = UnityEngine.Random.Range(
                            -1 * parameters.jointConfig[k + 1], parameters.jointConfig[k + 1]);

                        else if (k % 4 == 3) parameters.genome[i, j * 4 * parameters.joints.Length + k] = UnityEngine.Random.Range(-1f, 1f);
                    }
                }
            }

            // 時間の遺伝子
            for (int l = 4 * parameters.joints.Length * parameters.steps; l < 4 * parameters.joints.Length * parameters.steps + parameters.steps; l++)
            {
                rand = UnityEngine.Random.Range(0, parameters.mutationEvent + 1);
                if (rand == 1)
                {
                    parameters.genome[i, l] = UnityEngine.Random.Range(parameters.minStep, parameters.maxStep + 1);
                }
            }
        }
    }
}
