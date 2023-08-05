package com.damytech.dataclasses;

import org.json.JSONObject;

public class STGoodDetailInfo
{
    public long goodid = 0;
	public String name = "";
	public int price = 0;
	public String imgpath1 = "";
	public String imgpath2 = "";
	public String imgpath3 = "";
	public String imgpath4 = "";
	public String gooddesc = "";
	public String shopaddr = "";
	public String shopphone = "";
	public String buydesc = "";

    public static STGoodDetailInfo decode(JSONObject jsonObj)
    {
        STGoodDetailInfo goodInfo = new STGoodDetailInfo();

        try { goodInfo.goodid = jsonObj.getLong("uid"); } catch(Exception ex) {ex.printStackTrace();}
        try { goodInfo.name = jsonObj.getString("name"); } catch(Exception ex) {ex.printStackTrace();}
		try { goodInfo.price = jsonObj.getInt("price"); } catch(Exception ex) {ex.printStackTrace();}
        try { goodInfo.imgpath1 = jsonObj.getString("imgpath1"); } catch(Exception ex) {ex.printStackTrace();}
		try { goodInfo.imgpath2 = jsonObj.getString("imgpath2"); } catch(Exception ex) {ex.printStackTrace();}
		try { goodInfo.imgpath3 = jsonObj.getString("imgpath3"); } catch(Exception ex) {ex.printStackTrace();}
		try { goodInfo.imgpath4 = jsonObj.getString("imgpath4"); } catch(Exception ex) {ex.printStackTrace();}
		try { goodInfo.gooddesc = jsonObj.getString("gooddesc"); } catch(Exception ex) {ex.printStackTrace();}
		try { goodInfo.shopaddr = jsonObj.getString("shopaddr"); } catch(Exception ex) {ex.printStackTrace();}
		try { goodInfo.shopphone = jsonObj.getString("shopphone"); } catch(Exception ex) {ex.printStackTrace();}
		try { goodInfo.buydesc = jsonObj.getString("buydesc"); } catch(Exception ex) {ex.printStackTrace();}
        return goodInfo;
    }
}