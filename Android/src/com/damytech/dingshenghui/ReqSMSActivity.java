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

public class ReqSMSActivity extends SuperActivity {
    RelativeLayout mainLayout;
    boolean bInitialized = false;
    String strPhone = "";

    ImageView imgBack;
    Button btnNext;
    EditText txtVerify;

    JsonHttpResponseHandler handler;

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
                    String strVerify = txtVerify.getText().toString();
                    if (strVerify.length() != ConstData.VERIFYKEY_LENGTH)
                    {
                        GlobalData.showToast(ReqSMSActivity.this, getString(R.string.qingshuruliuweiyanzhengma));
                        return;
                    }

                    startProgress();
                    CommManager.ConfirmVerifyKey(strPhone, strVerify, handler);
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
        setContentView(R.layout.activity_reqsms);

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

        strPhone = getIntent().getStringExtra("PHONENUM");

        initControl();
        initHandler();
    }

    private void initControl()
    {
        imgBack = (ImageView) findViewById(R.id.imgBack);
        imgBack.setOnClickListener(onClickListener);

        btnNext = (Button) findViewById(R.id.btnNext);
        btnNext.setOnClickListener(onClickListener);

        txtVerify = (EditText) findViewById(R.id.txtVerifyKey);

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
                    String strRetMsg = jsonData.getString("RETDATA");

                    if (nRetCode == ConstData.ERR_SUCCESS)
                    {
                        Intent intent = new Intent(ReqSMSActivity.this, ResetPassActivity.class);
                        intent.putExtra("PHONENUM", strPhone);
                        startActivity(intent);

                        return;
                    }
                    else if (nRetCode == ConstData.ERR_INVALIDPARAM)
                    {
                        GlobalData.showToast(ReqSMSActivity.this, getString(R.string.ninshurudeyanzhengmabudui));
                        return;
                    }
                    else if (nRetCode == ConstData.ERR_VERIFYOVER)
                    {
                        GlobalData.showToast(ReqSMSActivity.this, getString(R.string.verifyover));

                        return;
                    }
                    else if (nRetCode == ConstData.ERR_VERIFYEXPIRE)
                    {
                        GlobalData.showToast(ReqSMSActivity.this, getString(R.string.verifyexpire));

                        return;
                    }
                    else if (nRetCode == ConstData.ERR_SERVERINTERNALERROR)
                    {
                        GlobalData.showToast(ReqSMSActivity.this, strRetMsg);

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
                GlobalData.showToast(ReqSMSActivity.this, getString(R.string.wangtongxuncuowu));
                stopProgress();
            }
        };

        return;
    }
}
