/*
 * Translated default messages for the jQuery validation plugin.
 * Locale: ZH (Chinese, 中文 (Zhōngwén), 汉语, 漢語)
 */
(function ($) {
	$.extend($.validator.messages, {
		required: "必填字段",
		remote: "请修正该字段",
		email: "请输入正确的电子信箱",
		url: "请输入合法的URL",
		date: "请输入合法的日期",
		dateISO: "请输入合法的的日期 (ISO).",
		number: "请输入合法的数字",
		digits: "只能输入整数",
		creditcard: "请输入合法的信用卡号码",
		equalTo: "请重复输入一次",
		accept: "请输入有效的后缀字串",
		maxlength: $.validator.format("请输入长度不大于 {0} 的字串"),
		minlength: $.validator.format("请输入长度不小于 {0} 的字串"),
		rangelength: $.validator.format("请输入长度介于 {0} 和 {1} 之间的字串"),
		range: $.validator.format("请输入介于 {0} 和 {1} 之间的数值"),
		max: $.validator.format("请输入不大于 {0} 的数值"),
		min: $.validator.format("请输入不小于 {0} 的数值")
	});
}(jQuery));