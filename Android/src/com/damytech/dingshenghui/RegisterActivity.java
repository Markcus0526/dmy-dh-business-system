package com.damytech.dingshenghui;

import android.app.Activity;
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

public class RegisterActivity extends SuperActivity {
    RelativeLayout mainLayout;
    boolean bInitialized = false;
    String strPhoneNum = "";

    ImageView imgBack;
    Button btnGain;
    Button btnNext;
    RelativeLayout rlNext;
    EditText txtPhone;
    EditText txtVerify;

    JsonHttpResponseHandler handlerReqVerifyKey = null;
    JsonHttpResponseHandler handlerConfirmVerifyKey = null;

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
                case R.id.btnGain:
                    rlNext.setVisibility(View.INVISIBLE);
                    btnNext.setVisibility(View.INVISIBLE);

                    strPhoneNum = txtPhone.getText().toString();
                    if (strPhoneNum.length() == 0)
                    {
                        GlobalData.showToast(RegisterActivity.this, getString(R.string.qingshurunindeshoujihaoma));
                        return;
                    }
                    if (strPhoneNum.length() != ConstData.PHONENUM_LENGTH)
                    {
                        GlobalData.showToast(RegisterActivity.this, getString(R.string.qingshurushiyiweishoujihaoma));
                        return;
                    }

                    startProgress();
                    CommManager.ReqVerifyKey(strPhoneNum, handlerReqVerifyKey);
                    break;
                case R.id.btnNext:
                    String strVerify = txtVerify.getText().toString();
                    if (strVerify.length() != ConstData.VERIFYKEY_LENGTH)
                    {
                        GlobalData.showToast(RegisterActivity.this, getString(R.string.qingshuruliuweiyanzhengma));
                        return;
                    }

                    startProgress();
                    CommManager.ConfirmVerifyKey(strPhoneNum, strVerify, handlerConfirmVerifyKey);
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
        setContentView(R.layout.activity_register);

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

        btnGain = (Button) findViewById(R.id.btnGain);
        btnGain.setOnClickListener(onClickListener);
        btnNext = (Button) findViewById(R.id.btnNext);
        btnNext.setOnClickListener(onClickListener);

        rlNext = (RelativeLayout) findViewById(R.id.relativeLayout3);

        txtPhone = (EditText) findViewById(R.id.txtPhone);
        txtVerify = (EditText) findViewById(R.id.txtVerifyKey);

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
                        rlNext.setVisibility(View.VISIBLE);
                        btnNext.setVisibility(View.VISIBLE);

                        return;
                    }
                    else if (nRetCode == ConstData.ERR_VERIFYOVER)
                    {
                        GlobalData.showToast(RegisterActivity.this, strRetMsg);

                        return;
                    }
                    else if (nRetCode == ConstData.ERR_INVALIDPARAM)
                    {
                        GlobalData.showToast(RegisterActivity.this, getString(R.string.paramerror));

                        return;
                    }
                    else if (nRetCode == ConstData.ERR_SERVERINTERNALERROR)
                    {
                        GlobalData.showToast(RegisterActivity.this, strRetMsg);

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
                GlobalData.showToast(RegisterActivity.this, getString(R.string.wangtongxuncuowu));
                stopProgress();
            }
        };

        handlerConfirmVerifyKey = new JsonHttpResponseHandler()
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
                        Intent intentNext = new Intent(RegisterActivity.this, RegInfoActivity.class);
                        intentNext.putExtra("PHONENUM", strPhoneNum);
                        startActivity(intentNext);

                        return;
                    }
                    else if (nRetCode == ConstData.ERR_INVALIDPARAM)
                    {
                        GlobalData.showToast(RegisterActivity.this, getString(R.string.ninshurudeyanzhengmabudui));
                        return;
                    }
                    else if (nRetCode == ConstData.ERR_VERIFYOVER)
                    {
                        GlobalData.showToast(RegisterActivity.this, getString(R.string.verifyover));

                        return;
                    }
                    else if (nRetCode == ConstData.ERR_VERIFYEXPIRE)
                    {
                        GlobalData.showToast(RegisterActivity.this, getString(R.string.verifyexpire));

                        return;
                    }
                    else if (nRetCode == ConstData.ERR_SERVERINTERNALERROR)
                    {
                        GlobalData.showToast(RegisterActivity.this, strRetMsg);

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
                GlobalData.showToast(RegisterActivity.this, getString(R.string.wangtongxuncuowu));
                stopProgress();
            }
        };

        return;
    }
}
