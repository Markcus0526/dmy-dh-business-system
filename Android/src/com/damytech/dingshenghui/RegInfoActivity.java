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

public class RegInfoActivity extends SuperActivity {
    RelativeLayout mainLayout;
    boolean bInitialized = false;
    String strPhoneNum = "";

    ImageView imgBack;
    Button btnRegister;
    EditText txtUserName;
    EditText txtPassword;
    EditText txtRePassword;

    JsonHttpResponseHandler handlerRegister = null;

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
                case R.id.btnRegister:
                    String strUserName = txtUserName.getText().toString();
                    if (strUserName.length() == 0)
                    {
                        GlobalData.showToast(RegInfoActivity.this, getString(R.string.qingshuruyonghuming));
                        return;
                    }
                    String strPassword = txtPassword.getText().toString();
                    if (strPassword.length() == 0)
                    {
                        GlobalData.showToast(RegInfoActivity.this, getString(R.string.qingshurumima));
                        return;
                    }
                    String strRePassword = txtRePassword.getText().toString();
                    if (strRePassword.length() == 0)
                    {
                        GlobalData.showToast(RegInfoActivity.this, getString(R.string.qingshurumima));
                        return;
                    }
                    if (strPassword.equals(strRePassword) == false)
                    {
                        GlobalData.showToast(RegInfoActivity.this, getString(R.string.notmatchpassword));
                        return;
                    }

                    startProgress();
                    CommManager.RegisterUser(strUserName, strPassword, strPhoneNum, GlobalData.getIMEI(RegInfoActivity.this), handlerRegister);
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
        setContentView(R.layout.activity_reginfo);

        strPhoneNum = getIntent().getStringExtra("PHONENUM");

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

        btnRegister = (Button) findViewById(R.id.btnRegister);
        btnRegister.setOnClickListener(onClickListener);

        txtUserName = (EditText) findViewById(R.id.txtUserName);
        txtPassword = (EditText) findViewById(R.id.txtPass);
        txtRePassword = (EditText) findViewById(R.id.txtRePass);

        return;
    }

    public void initHandler()
    {
        handlerRegister = new JsonHttpResponseHandler()
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
                        long nUID = jsonData.getLong("RETDATA");

                        GlobalData.SetPassFlag(RegInfoActivity.this, true);
                        GlobalData.SetUserID(RegInfoActivity.this, nUID);
                        GlobalData.SetUserName(RegInfoActivity.this, txtUserName.getText().toString());
                        GlobalData.SetPass(RegInfoActivity.this, txtPassword.getText().toString());

                        Intent intentLogin = new Intent(RegInfoActivity.this, MainMenuActivity.class);
                        startActivity(intentLogin);

                        return;
                    }
                    else if (nRetCode == ConstData.ERR_NOTEXISTUSER)
                    {
                        GlobalData.showToast(RegInfoActivity.this, getString(R.string.notexistuser));

                        return;
                    }
                    else if (nRetCode == ConstData.ERR_EXISTEDUSER)
                    {
                        GlobalData.showToast(RegInfoActivity.this, getString(R.string.existeduser));

                        return;
                    }
                    else if (nRetCode == ConstData.ERR_EXISTEDPHONE)
                    {
                        GlobalData.showToast(RegInfoActivity.this, getString(R.string.existedphone));

                        return;
                    }
                    else if (nRetCode == ConstData.ERR_SERVERINTERNALERROR)
                    {
                        GlobalData.showToast(RegInfoActivity.this, getString(R.string.fuwuqineibucuowu));

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
                GlobalData.showToast(RegInfoActivity.this, getString(R.string.wangtongxuncuowu));
                stopProgress();
            }
        };

        return;
    }
}
