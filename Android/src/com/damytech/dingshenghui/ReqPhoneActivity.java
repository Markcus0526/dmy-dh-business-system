package com.damytech.dingshenghui;

import android.content.Intent;
import android.graphics.Rect;
import android.os.Bundle;
import android.view.View;
import android.view.ViewTreeObserver;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import com.damytech.HttpConn.JsonHttpResponseHandler;
import com.damytech.misc.CommManager;
import com.damytech.misc.ConstData;
import com.damytech.utils.GlobalData;
import com.damytech.utils.ResolutionSet;
import org.json.JSONObject;

public class ReqPhoneActivity extends SuperActivity {
    RelativeLayout mainLayout;
    boolean bInitialized = false;
    String strPhone = "";

    ImageView imgBack;
    Button btnNext;
    EditText txtPhone;

    JsonHttpResponseHandler handlerReqVerifyKey = null;

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
                case R.id.btnNext:
                    strPhone = txtPhone.getText().toString();
                    if (strPhone.length() == 0)
                    {
                        GlobalData.showToast(ReqPhoneActivity.this, getString(R.string.qingshurunindeshoujihaoma));
                        return;
                    }
                    if (strPhone.length() != ConstData.PHONENUM_LENGTH)
                    {
                        GlobalData.showToast(ReqPhoneActivity.this, getString(R.string.qingshurushiyiweishoujihaoma));
                        return;
                    }

                    startProgress();
                    CommManager.ReqVerifyKey(strPhone, handlerReqVerifyKey);
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
        setContentView(R.layout.activity_reqphone);

        mainLayout = (RelativeLayout)findViewById(R.id.parent_layout);
        mainLayout.getViewTreeObserver().addOnGlobalLayoutListener(
                new ViewTreeObserver.OnGlobalLayoutListener() {
                    public void onGlobalLayout() {
                        if (bInitialized == false)
                        {
                            Rect r = new Rect();
                            mainLayout.getLocalVisibleRect(r);
                            ResolutionSet._instance.setResolution(r.width(), r.height());
                            ResolutionSet._instance.iterateChild(findViewById(R.id.parent_layout));
                            bInitialized = true;
                        }
                    }
                }
        );

        initControl();
        initHandler();
    }

    private void initControl()
    {
        imgBack = (ImageView) findViewById(R.id.imgBack);
        imgBack.setOnClickListener(onClickListener);

        btnNext = (Button) findViewById(R.id.btnNext);
        btnNext.setOnClickListener(onClickListener);

        txtPhone = (EditText) findViewById(R.id.txtPhone);

        return;
    }

    private void initHandler()
    {
        handlerReqVerifyKey = new JsonHttpResponseHandler()
        {
            @Override
            public void onSuccess(JSONObject jsonData)
            {
                stopProgress();

                try
                {
                    int nRetCode = jsonData.getInt("RETVAL");
                    String strRetMsg = jsonData.getString("RETDATA");

                    if (nRetCode == ConstData.ERR_SUCCESS)
                    {
                        Intent intent = new Intent(ReqPhoneActivity.this, ReqSMSActivity.class);
                        intent.putExtra("PHONENUM", strPhone);
                        startActivity(intent);

                        return;
                    }
                    else if (nRetCode == ConstData.ERR_VERIFYOVER)
                    {
                        GlobalData.showToast(ReqPhoneActivity.this, strRetMsg);

                        return;
                    }
                    else if (nRetCode == ConstData.ERR_INVALIDPARAM)
                    {
                        GlobalData.showToast(ReqPhoneActivity.this, getString(R.string.paramerror));

                        return;
                    }
                    else if (nRetCode == ConstData.ERR_SERVERINTERNALERROR)
                    {
                        GlobalData.showToast(ReqPhoneActivity.this, strRetMsg);

                        return;
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
                GlobalData.showToast(ReqPhoneActivity.this, getString(R.string.wangtongxuncuowu));
                stopProgress();
            }
        };

        return;
    }
}
