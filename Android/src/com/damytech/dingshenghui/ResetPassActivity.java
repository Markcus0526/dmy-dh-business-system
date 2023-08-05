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

public class ResetPassActivity extends SuperActivity {
    RelativeLayout mainLayout;
    boolean bInitialized = false;
    String strPhone = "";

    ImageView imgBack;
    Button btnNext;
    EditText txtPassword;
    EditText txtRePassword;

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
                case R.id.btnNext:
                    String strPass = txtPassword.getText().toString();
                    if (strPass.length() < ConstData.PASSWORD_LENGTH)
                    {
                        GlobalData.showToast(ResetPassActivity.this, getString(R.string.qingshuruwuweimima));
                        return;
                    }
                    String strRePass = txtRePassword.getText().toString();
                    if (strRePass.length() < ConstData.PASSWORD_LENGTH)
                    {
                        GlobalData.showToast(ResetPassActivity.this, getString(R.string.qingshuruwuweimima));
                        return;
                    }
                    if (strPass.equals(strRePass) == false)
                    {
                        GlobalData.showToast(ResetPassActivity.this, getString(R.string.notmatchpassword));
                        return;
                    }

                    startProgress();
                    CommManager.ResetPassword(GlobalData.GetUserID(ResetPassActivity.this), strPhone, strPass, handler);

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
        setContentView(R.layout.activity_resetpass);

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

        txtPassword = (EditText) findViewById(R.id.txtPass);
        txtRePassword = (EditText) findViewById(R.id.txtRePass);

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
                        GlobalData.showToast(ResetPassActivity.this, getString(R.string.caozuochenggong));

                        Intent intent = new Intent(ResetPassActivity.this, LoginActivity.class);
                        intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_NEW_TASK);
                        startActivity(intent);

                        return;
                    }
                    else if (nRetCode == ConstData.ERR_NOTEXISTPHONE)
                    {
                        GlobalData.showToast(ResetPassActivity.this, getString(R.string.notexistphone));

                        return;
                    }
                    else if (nRetCode == ConstData.ERR_NOTEXISTUSER)
                    {
                        GlobalData.showToast(ResetPassActivity.this, getString(R.string.notexistuser));

                        return;
                    }
                    else if (nRetCode == ConstData.ERR_SERVERINTERNALERROR)
                    {
                        GlobalData.showToast(ResetPassActivity.this, strRetMsg);

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
                GlobalData.showToast(ResetPassActivity.this, getString(R.string.wangtongxuncuowu));
                stopProgress();
            }
        };

        return;
    }
}
