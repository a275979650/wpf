<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ attribute name="id" type="java.lang.String" required="true" description="编号"%>
<%@ attribute name="name" type="java.lang.String" required="true" description="隐藏域名称（ID）"%>
<%@ attribute name="value" type="java.lang.String" required="true" description="隐藏域值（ID）"%>
<%@ attribute name="labelName" type="java.lang.String" required="true" description="输入框名称（Name）"%>
<%@ attribute name="labelValue" type="java.lang.String" required="true" description="输入框值（Name）"%>
<%@ attribute name="title" type="java.lang.String" required="true" description="选择框标题"%>
<%@ attribute name="checked" type="java.lang.Boolean" required="false" description="是否显示复选框"%>
<%@ attribute name="disabled" type="java.lang.String" required="false" description="是否限制选择，如果限制，设置为disabled"%>
<%@ attribute name="cssClass" type="java.lang.String" required="false" description="css样式"%>
<%@ attribute name="cssStyle" type="java.lang.String" required="false" description="css样式"%>
<%@ attribute name="roleId" type="java.lang.String" required="false" description="角色id"%>
<%@ attribute name="dataScope" type="java.lang.String" required="false" description="查看数据范围(人事处＝2，学院＝3)"%>
<div class="input-append">
	<input id="${id}Id" name="${name}" class="${cssClass}" type="hidden" value="${value}"${disabled eq 'true' ? ' disabled=\'disabled\'' : ''}/>
	<input id="${id}Name" name="${labelName}" readonly="readonly" type="text" value="${labelValue}" maxlength="4000"${disabled eq "true"? " disabled=\"disabled\"":""}"
		class="${cssClass}" style="${cssStyle}"/>
	<a id="${id}Button" href="javascript:" class="btn${disabled eq 'true' ? ' disabled' : ''}">
    		<i class="icon-search"></i>
    </a>&nbsp;&nbsp;
</div>
<script type="text/javascript">

	var employeeSelected2 = [];
	var employeeNameSelected2 = [];
	var ids = "${value}";
	var names = "${labelValue}";
	if(ids!="" && names!=""){
		employeeSelected2 = ids.split(",");
		employeeNameSelected2 = names.split(",");
	}
	$("#${id}Button").click(function(){
		var sortValue = employeeSelected2;
		
		// 是否限制选择，如果限制，设置为disabled
		if ($("#${id}Id").attr("disabled")){
			return true;
		}
		// 正常打开	
		$.jBox.open("iframe:${ctx}/sys/empSelect/listEmployee?checked=${checked}&sortValue="+sortValue, "选择${title}", 600, 400, {
			buttons:{"确定":"ok","关闭":true}, submit:function(v, h, f){
				if (v=="ok"){
					/*var table = h.find("iframe")[0].contentWindow.contentTable;//h.find("iframe").contents();
					var ids = [], names = []
					if ("${checked}" == "true"){
						$(table).find("input[name='rowSelect']").each(function(){
							if($(this).attr("checked")){
								ids.push($(this).val());
								var objjson = $(this).attr("object");
								var obj = $.parseJSON(objjson.replace(new RegExp("'","gm"),"\""));
								names.push(obj.name);
							}
						})
					}else{
						//实现获取单行记录
					}*/
					var checked = "${checked}";
					if(checked !="true"){
						if(employeeSelected2.length>1){
							top.$.jBox.error("请选择一行记录！", "提示");
							return false;
						}
					}
					$("#${id}Id").val(employeeSelected2);
					$("#${id}Name").val(employeeNameSelected2);
					//var ids = $("#${id}Id").val();
					//employeeSelected2 = ids.split(",");
				}
				/*else if (v=="clear"){
					$("#${id}Id").val("");
					$("#${id}Name").val("");
                }*/
			},top:20, loaded:function(h){
				$(".jbox-content", document).css("overflow-y","hidden");
			}
		});
	});
</script>
