using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using System.Linq;

public class GraphView : MonoBehaviour
{
    private RectTransform m_rtView;

    private RectTransform m_templateLabelX;
    private RectTransform m_templateLabelY;

    private RectTransform m_templateVertical;
    private RectTransform m_templateHorizontal;

    private bool open = false;

    void LateUpdate()
    {
        if (Input.GetKeyDown(KeyCode.Q) && open == false)
        {
            open = true;
            GraphAwake();
        }
        if (Input.GetKeyDown(KeyCode.C))
        {
            open = false;
        }
    }

    public Puzzle puzzleScript;
    private void GraphAwake()
    {
        m_rtView = transform.Find("View").GetComponent<RectTransform>();

        m_templateLabelX = transform.Find("View/LabelX").GetComponent<RectTransform>();
        m_templateLabelY = transform.Find("View/LabelY").GetComponent<RectTransform>();

        m_templateVertical = transform.Find("View/BarVertical").GetComponent<RectTransform>();
        m_templateHorizontal = transform.Find("View/BarHorizontal").GetComponent<RectTransform>();

        // 以下テストデータ
        // puzzleScript.historicalList = new List<float> { 125.6f, 137.8f, 118.1f, 90.4f, 110.5f, 121.1f, 102.4f, 72.5f, 100.7f, 96.6f, 94.6f, 90.2f, 89.6f, 100.6f, 82.4f, 85.7f, 62.1f, 93.6f, 80.1f, 77.9f, 95.2f ,75.4f, 72.8f, 70.1f, 44.5f, 68.9f, 64.1f, 88.2f ,56.1f, 53.2f };

        LeastSquares(puzzleScript.historicalList);
        ShowGraph(puzzleScript.historicalList);
    }

    // 1つの点を描写
    private GameObject CreateDot(Vector2 _position)
    {
        GameObject objDot = new GameObject("dot", typeof(Image));
        objDot.GetComponent<Image>().color = Color.black;  // ドットの色を黒にする
        objDot.transform.SetParent(m_rtView, false);
        RectTransform rtDot = objDot.GetComponent<RectTransform >();

        rtDot.anchoredPosition = _position;
        rtDot.sizeDelta = new Vector2(5f, 5f);   // ドットの大きさ
        rtDot.anchorMin = Vector2.zero;
        rtDot.anchorMax = Vector2.zero;

        return objDot;
    }

    // Listから一つずつデータ点の座標を割り出し、描画するメソッドに渡す
    private void ShowGraph(List<float> _dataList)
    {
        float fGraphHeight = m_rtView.sizeDelta.y;
        float fGraphWidth = m_rtView.sizeDelta.x;
        float fMaxY = _dataList.Max();   // グラフの最大値
        // float fPitchX = 50f;  // x方向のデータ距離
        float fOffsetX = 30f; // グラフの0をどこに置くか

        GameObject objLast = null;

        for(int i = 0; i < _dataList.Count; i++)
        {
            float fPosX = (fGraphWidth - fOffsetX) / _dataList.Count * i + fOffsetX;  // グラフの横幅からoffsetずらし、残りをデータ個数等分してi番目をxとする
            float fPosY = (_dataList[i] / (_dataList.Max()) * fGraphHeight);    // データ群の最大値で割って割合にし、グラフの高さを掛ける
            GameObject objDot = CreateDot(new Vector2(fPosX, fPosY));

            if(objLast != null)
            {
                CreateLine(objLast.GetComponent<RectTransform>().anchoredPosition, objDot.GetComponent<RectTransform>().anchoredPosition ,new Vector4(0f,0f,0f,0.5f));
                // 前のループの点と現在のループの点の2点を引数にして線を描写する
            }
            objLast = objDot;

            // X軸のラベルを描画
            RectTransform rtLabelX = Instantiate(m_templateLabelX, m_rtView);
            rtLabelX.gameObject.SetActive(true);
            rtLabelX.anchoredPosition = new Vector2(fPosX, 0f);
            rtLabelX.GetComponent<Text>().text = (i+1).ToString();

            // Xグリッドを描画
            RectTransform rtBarVertical = Instantiate(m_templateVertical, m_rtView);
            rtBarVertical.gameObject.SetActive(true);
            rtBarVertical.anchoredPosition = new Vector2(fPosX, 0f);
        }

        // Y軸のラベル、グリッドを描画
        int verticalCount = 10;  // 縦軸をN分割する
        for(int i=0; i <= verticalCount; i++)
        {
            // ラベル
            RectTransform rtLabelY = Instantiate(m_templateLabelY, m_rtView);
            rtLabelY.gameObject.SetActive(true);

            float normalizedValue = i * 1f / verticalCount;
            float labelHeight = normalizedValue * fGraphHeight;

            rtLabelY.anchoredPosition = new Vector2(0f, labelHeight);

            if (_dataList.Max() < 0f)
            {
                rtLabelY.GetComponent<Text>().text = (normalizedValue * fMaxY).ToString("f2");
            }
            rtLabelY.GetComponent<Text>().text = (normalizedValue * fMaxY).ToString("f0");

            // グリッド
            RectTransform rtBarHorizontal = Instantiate(m_templateHorizontal, m_rtView);
            rtBarHorizontal.gameObject.SetActive(true);
            rtBarHorizontal.anchoredPosition = new Vector2(0f, labelHeight);
        }
    }

    //点と点を結ぶ直線を描画
    private void CreateLine(Vector2 _pointA, Vector2 _pointB, Vector4 _color)
    {
        GameObject objLine = new GameObject("dotLine", typeof(Image));
        objLine.GetComponent<Image>().color = _color;  // 線の色を指定
        objLine.transform.SetParent(m_rtView, false);

        RectTransform rtLine = objLine.GetComponent<RectTransform>();

        Vector2 dir = (_pointB - _pointA).normalized;   // 線の向きは(現在の点 - 前の点)でベクトルが得られるのでそれを正規化する
        float fDistance = Vector2.Distance(_pointA, _pointB);    // 線の長さは減算するだけ

        rtLine.anchorMin = Vector2.zero;
        rtLine.anchorMax = Vector2.zero;

        rtLine.sizeDelta = new Vector2(fDistance, 5f);   // 成分は(線の長さ, 線の太さ)
        rtLine.localEulerAngles = new Vector3(0f, 0f, Vector2.SignedAngle(new Vector2(1f, 0f), dir));  // 2点間の傾きを得る

        rtLine.anchoredPosition = _pointA + dir * fDistance * 0.5f;
    }


    private void LeastSquares(List<float> _data)
    {
        float SumX = (1f + _data.Count) / 2f * _data.Count;   // Yの和
        float SumY = _data.Sum();                             // Xの和

        float[] XSquared = new float[_data.Count];
        float[] YSquared = new float[_data.Count];
        float[] multipleXY = new float[_data.Count];
        for (int i = 0; i < _data.Count; i++)     // X^2の和、Y^2の和、X*Yの和
        {
            XSquared[i] = (i + 1f) * (i + 1f);
            YSquared[i] = _data[i] * _data[i];
            multipleXY[i] = _data[i] * (i + 1f);
        }
        float SumXSquared = XSquared.Sum();
        float SumYSquared = YSquared.Sum();
        float SumMultipleXY = multipleXY.Sum();

        float slope = (_data.Count * SumMultipleXY - (SumX * SumY)) / (_data.Count * SumXSquared - SumX * SumX);
        float intercept = (SumXSquared * SumY - SumMultipleXY * SumX) / (_data.Count * SumXSquared - SumX * SumX);

        Vector2 PointA = new Vector2(0f, slope * 1f + intercept);
        Vector2 PointB = new Vector2(_data.Count-1f, slope * _data.Count + intercept);

        float fGraphWidth = m_rtView.sizeDelta.x;
        float fGraphHeight = m_rtView.sizeDelta.y;
        float fOffsetX = 30f;
        PointA.x = (fGraphWidth - fOffsetX) / _data.Count * PointA.x + fOffsetX;
        PointB.x = (fGraphWidth - fOffsetX) / _data.Count * PointB.x + fOffsetX;
        PointA.y = (PointA.y / (_data.Max()) * fGraphHeight);
        PointB.y = (PointB.y / (_data.Max()) * fGraphHeight);

        CreateLine(PointA, PointB, new Vector4(150f,0f,0f,0.5f));
    }
}
