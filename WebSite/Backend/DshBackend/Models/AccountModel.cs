using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Globalization;
using System.Web.Mvc;
using System.Web.Security;
using System.Text;
using System.Security.Cryptography;

namespace DshBackend.Models
{

    #region Models

    public class LogOnModel
    {
        [Required(ErrorMessage = "用户名不能为空")]
        [DisplayName("用户名:")]
        public string UserName { get; set; }

        [Required(ErrorMessage = "密码不能为空")]
        [ValidatePasswordLength]
        [DataType(DataType.Password)]
        [DisplayName("密码:")]
        public string Password { get; set; }

        [DisplayName("下次自动登录")]
        public string RememberMe { get; set; }
    }

    #endregion

    public class Foreign_Servant
    {
        public long Id { get; set; }
        public string Name { get; set; }
    }

    [AttributeUsage(AttributeTargets.Field | AttributeTargets.Property, AllowMultiple = false, Inherited = true)]
    public sealed class ValidatePasswordLengthAttribute : ValidationAttribute
    {
        private const string _defaultErrorMessage = "{0}至少为{1}位.";
        private readonly int _minCharacters = 1;

        public ValidatePasswordLengthAttribute()
            : base(_defaultErrorMessage)
        {
        }

        public override string FormatErrorMessage(string name)
        {
            return String.Format(CultureInfo.CurrentUICulture, ErrorMessageString,
                name, _minCharacters);
        }

        public override bool IsValid(object value)
        {
            string valueAsString = value as string;
            return (valueAsString != null && valueAsString.Length >= _minCharacters);
        }
    }

    public class AccountModel
    {
        private DshDBModelDataContext db = new DshDBModelDataContext();

        public int UpdateFailedCount(string addr, bool isFaild)
        {
            if (isFaild)
            {
                if (HttpContext.Current.Session[addr] == null)
                {
                    HttpContext.Current.Session.Add(addr, 1);

                    return 1;
                }
                else
                {
                    int faildcount = (int)HttpContext.Current.Session[addr];
                    faildcount++;
                    HttpContext.Current.Session[addr] = faildcount;

                    return faildcount;
                }
            }
            else
            {
                if (HttpContext.Current.Session[addr] != null)
                    HttpContext.Current.Session[addr] = 0;
            }

            return -1;
        }

        public tbl_admin ValidateUser(string username, string password)
        {
            tbl_admin userObj = GetUserObjByUserNameOrMailAddr(username, password);

            if (userObj != null)
                return userObj;
            return null;
        }

        public tbl_admin GetUserObjByUserNameOrMailAddr(string userName, string passWord)
        {
            try
            {
                tbl_admin userinfo = (from m in db.tbl_admins
                                     where m.username.ToLower() == userName.ToLower() &&
                                       m.password == passWord && m.deleted == 0
                                     select m).FirstOrDefault();

                if (userinfo != null)
                {
                    return userinfo;
                }
            }
            catch (Exception e)
            {
                CommonModel.WriteLogFile(this.GetType().Name, "GetUserObjByUserNameOrMailAddr()", e.ToString());
            }
            return null;
        }

        public tbl_shop ValidateShop(string username, string password)
        {
            tbl_shop userObj = GetShopObjByUserNameOrMailAddr(username, password);

            if (userObj != null)
                return userObj;
            return null;
        }

        public tbl_shop GetShopObjByUserNameOrMailAddr(string userName, string passWord)
        {
            try
            {
                tbl_shop userinfo = (from m in db.tbl_shops
                                      where m.shopid.ToLower() == userName.ToLower() &&
                                        m.password == passWord && m.deleted == 0
                                      select m).FirstOrDefault();

                if (userinfo != null)
                {
                    return userinfo;
                }
            }
            catch (Exception e)
            {
                CommonModel.WriteLogFile(this.GetType().Name, "GetShopObjByUserNameOrMailAddr()", e.ToString());
            }
            return null;
        }

        /*public bool SetLoginInfo(long id, string lastip)
        {
            try
            {
                tbl_admin item = (from m in db.tbl_admins
                                  where m.deleted == 0 && m.id == id
                                  select m).FirstOrDefault();
                if (item != null)
                {
                    item.lastregtime = DateTime.Now;
                    item.lastIP = lastip;
                    db.SubmitChanges();

                    return true;
                }
            }
            catch (Exception e)
            {
                CommonModel.WriteLogFile("AccountModel", "SetLoginInfo()", e.ToString());
                return false;
            }

            return false;
        }*/

        public string GetRolesById(long uid)
        {
            var item = db.tbl_adminroles
                .Where(m => m.deleted == 0 && m.uid == uid)
                .FirstOrDefault();
            if (item != null)
                return item.roledata;
            else
                return "";
        }

        public void SignOut()
        {
            FormsAuthentication.SignOut();
        }
    }
}
