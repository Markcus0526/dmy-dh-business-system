package com.damytech.dingshenghui;

import android.graphics.Rect;
import android.os.Bundle;
import android.view.View;
import android.view.ViewTreeObserver;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import com.damytech.HttpConn.JsonHttpResponseHandler;
import com.damytech.dataclasses.STGoodStatusItem;
import com.damytech.misc.CommManager;
import com.damytech.misc.ConstData;
import com.damytech.utils.GlobalData;
import com.damytech.utils.ImageRatingView;
import com.damytech.utils.ResolutionSet;
import org.json.JSONArray;
import org.json.JSONObject;

public class EvaluteActivity extends SuperActivity {
    RelativeLayout mainLayout;
    boolean bInitialized = false;

    long nGoodID = 0;
    long nSaleID = 0;

    ImageView imgBack;
    ImageRatingView ratingView;
    Button btnEval;

    JsonHttpResponseHandler handler = null;

    View.OnClickListener onClickListener = new View.OnClickListener()
    {
        @Override
        public void onClick(View v)
        {
            switch (v.getId())
            {
                case R.id.imgBack:
                    finish();
                    break;
                case R.id.btnEvalute:
                    startProgress();
                    CommManager.SetGoodEval(GlobalData.GetUserID(EvaluteActivity.this),
                            nGoodID,
                            nSaleID,
                            (int)(ratingView.getCurVal()),
                            handler);
                    break;
            }
        }
    };

    /**
     * Called when the activity is first created.
     */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_evalute);

        mainLayout = (RelativeLayout)findViewById(R.id.parent_layout);
        mainLayout.getViewTreeObserver().addOnGlobalLayoutListener(
                new ViewTreeObserver.OnGlobalLayoutListener() {
                    public void onGlobalLayout() {
                        if (bInitialized == false) {
                            Rect r = new Rect();
                            mainLayout.getLocalVisibleRect(r);
                            ResolutionSet._instance.setResolution(r.width(), r.height());
                            ResolutionSet._instance.iterateChild(findViewById(R.id.parent_layout));
                            bInitialized = true;
                        }
                    }
                }
        );

        nGoodID = getIntent().getLongExtra("GOODID", 0);
        nSaleID = getIntent().getLongExtra("SALEID", 0);

        initControl();
        initHandler();
    }

    private void initControl()
    {
        imgBack = (ImageView) findViewById(R.id.imgBack);
        imgBack.setOnClickListener(onClickListener);

        ratingView = (ImageRatingView)findViewById(R.id.viewStar);
        ratingView.fillImage(R.drawable.star_fill_pad);
        ratingView.emptyImage(R.drawable.star_empty_pad);
        ratingView.defaultValue(5);
        ratingView.ratingListener(new ImageRatingView.ImageRatingListener() {
            @Override
            public void ratingChanged(double fRate) {}
        });
        ratingView.step(1);

        btnEval = (Button) findViewById(R.id.btnEvalute);
        btnEval.setOnClickListener(onClickListener);

        return;
    }

    private void initHandler()
    {
        handler = new JsonHttpResponseHandler()
        {
            @Override
            public void onSuccess(JSONObject jsonData)
            {
                stopProgress();

                try
                {
                    int nRetCode = jsonData.getInt("RETVAL");
                    if (nRetCode == ConstData.ERR_SUCCESS)
                    {
                        GlobalData.showToast(EvaluteActivity.this, getString(R.string.caozuochenggong));
                        finish();

                        return;
                    }
                    else if (nRetCode == ConstData.ERR_SERVERINTERNALERROR)
                    {
                        GlobalData.showToast(EvaluteActivity.this, getString(R.string.fuwuqineibucuowu));
                    }
                }
                catch (Exception ex)
                {
                    ex.printStackTrace();
                };
            }

            @Override
            public void onFailure(Throwable error, String content) {
                super.onFailure(error, content);
                GlobalData.showToast(EvaluteActivity.this, getString(R.string.wangtongxuncuowu));
                stopProgress();
                finish();
            }
        };

        return;
    }
}
