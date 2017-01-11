<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>账单管理</title>
<meta name="decorator" content="default" />
<%@include file="/WEB-INF/views/include/dialog.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		$("#tableHead").click(function() {
			if ($(this).attr("checked")) {
				$("#contentTable tbody :checkbox[name='rowSelect']").attr("checked", true);
				} else {
					$("#contentTable tbody :checkbox[name='rowSelect']").attr("checked", false);
				}
		});

		$("#export").click(function() {
			var submit = function(v, h, f) {
				if (v == 'ok') {
					$("#exportForm").submit();
				}
				return true;
			};

			$.jBox.confirm("确认批量导出吗？", "提示", submit);

		});
});
function page(n, s) {
	$("#pageNo").val(n);
	$("#pageSize").val(s);
	$("#searchForm").attr("action", "${ctx}/bill/list");
	$("#searchForm").submit();
	return false;
}
function reload() {
	window.location.href = "${ctx}/bill/list";
}
function modify(guid,siteName) {
	var index = layer.open({
		type: 2,
		area: ['800px', '450px'],
		maxmin: true,
		title: siteName,
		content: "${ctx}/bill/form?numId="+guid,
		btn: ['保存','返回'],
		btnAlign: 'c',
		offset: "auto",
		yes: function (index, layero) {
			//需要提交图片文件无法异步提交
			layer.getChildFrame('#inputForm', index).submit();
			setTimeout(function(){
				layer.close(index);
				top.layer.msg("操作成功！", {time: 1500, icon:6});
				$("#searchForm").submit();
			},2000); 
		},btn2: function (index) {
			layer.close(index);
		}
	});
}
function del(guid){
	layer.confirm("确认删除账单信息吗？", {
	    title: '提示', icon: 0,
	    btn: ['确定', '取消'] //按钮
	}, function () {
	    $.ajax({
	        type: "post",
	        data: {"numId": guid},
	        dataType: "text",
	        url: "${ctx}/bill/delete",
	        success: function (data) {
	        	if(data=="OK"){
			    	top.layer.msg("操作成功！", {time: 1500, icon:6});
			    	$('#searchForm').submit();
				}else{
					layer.msg("操作失败："+data,{time:2000,icon:2});
				}
	        }
	    });
	});
}

function detail(guid) {
	var index = layer.open({
		type: 2,
		area: ['800px', '450px'],
		maxmin: true,
		title: "账单详细",
		content: "${ctx}/bill/view?numId="+guid,
		btn: ['关闭'],
		offset: "auto",
		yes: function (index, layero) {
	    	layer.close(index);
		},cancel: function (index) {
			layer.close(index);
		}
	});
}
function importData() {
	top.$.jBox.open("iframe:${ctx}/comm/import/index?dicId=T_COMM_BASE_INFO","基本工资导入",550,450,{
		buttons : {"关闭" : true},
		submit : function(v, h, f) {
			window.location.href = "${ctx}/bill/list";
		},
		bottomText : "导入文件不能超过5M，仅允许导入“xls”或“xlsx”格式文件！",
		loaded : function(h) {
			$(".jbox-content", top.document).css("overflow-y", "hidden");
		}
	});
}
</script>
</head>
<body>
	<div style="display:none;"><tags:orgmessage content="${message}" /></div>
	<form:form id="exportForm" modelAttribute="map"
		class="breadcrumb form-search" method="post" style="display:none;" action="${ctx}/demo/export">
		<input type="hidden" name="bean['ITEM']" value="${map.bean['ITEM'] }">
		<input type="hidden" name="bean['DEPT_ID']" value="${map.bean['DEPT_ID'] }">
	</form:form>
	<form:form id="searchForm" modelAttribute="map" class="breadcrumb form-search" method="post"
		action="${ctx}/bill/list">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}" />
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}" />
		<table border="0">
			<tr>
				<td><label>收支类型：</label></td>
				<td><form:select path="bean['CONSUME_TYPE']" class="input-small">
						<form:option value="" label="---请选择---"/>
						<form:options items="${fns:getDictList('BILL_IN_OUT_TYPE')}" 
							itemValue="value" itemLabel="label" htmlEscape="false"/>
					</form:select></td>
				<td><label>分类标签：</label> </td>
				<td><tags:treeselect id="LABEL" name="bean['LABEL']" value="${map.bean.LABEL}" 
					labelName="bean['LABEL_NAME']" labelValue="${map.bean.LABEL_NAME}" title="分类标签" 
					url="/bill/comm/treeData" extId="${map.bean.LABEL}" allowClear="true" cssStyle="width:82px;"/>
				</td>
				<td><label>账单时间：</label></td>
				<td><input type="text" name="bean['BEGIN_TIME']" class="input-small Wdate"  
						value="${map.bean['BEGIN_TIME']}" 
						onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});" /></td>
				<td>--&nbsp;<input type="text" name="bean['END_TIME']" class="input-small Wdate"  
					    value="${map.bean['END_TIME']}" 
					    onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});" /></td>
			</tr>
			<tr>
				<td><label>地点：</label></td>
				<td><form:input path="bean['PLACE']" htmlEscape="false"
						maxlength="32" class="input-small" /></td>
				<td><label>内容：</label></td>
				<td><form:input id="ITEM" path="bean['ITEM']" htmlEscape="false"
						maxlength="32" class="input-small" /></td>
				<td><label>支付方式：</label></td>
				<td><form:select path="bean['PAY_WAY']" class="input-small" >
							<form:option value="" label="---请选择---"/>
							<form:options items="${fns:getDictList('BILL_PAY_WAY')}" 
							itemValue="value" itemLabel="label" htmlEscape="false"/>
						</form:select></td>
				<td>
					&nbsp;&nbsp; <input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"
						onclick="return page();">
					<input id="btnCancel" class="btn btn-primary" type="button" value="重置"
						onclick="return reload();" />&nbsp;&nbsp; 
					<input class="btnImpAndExp  btn-primaryImpAndExp" type="button" value="导入"
						onclick="importData();">&nbsp;&nbsp; 
					<input id="export" class="btnImpAndExp btn-primaryImpAndExp" type="button" value="导出">
					<a href="javascript:modify('','添加账单记录');" class="btn btn-primary"><i class="iconfont f16 mr5">&#xe63f;</i>添加</a>
				</td>
			</tr>
		</table>
	</form:form>
	<table id="contentTable"
		class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th width="12px"><input type="checkbox" id="tableHead"></th>
				<th>账单主体</th>
				<th width="120px">发生时间</th>
				<th>收支类型</th>
				<th>分类标签</th>
				<th>金额（元）</th>
				<th>账单内容</th>
				<th>交易地点</th>
				<th width="100px">支付方式</th>
				<th>备注</th>
				<th width="100px">操作</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${page.list}" var="bean">
				<tr>
				<td><input type="checkbox" name="rowSelect"
					value="${bean['GUUID']}" /></td>
				<td width="70px">${bean['BLONG_NAME']}</td>
				<td>${fns:formatDate(bean['CONSUME_TIME'], 'yyyy-MM-dd HH:mm:ss') }</td>
				<td>${fns:getDictLabel(bean['CONSUME_TYPE'], 'BILL_IN_OUT_TYPE', '')}</td>
				<td>${fns:getBillLabelBySeparator(bean['LABEL'], '', '')}</td>
				<td>${bean['AMOUNT']}</td>
				<td><a href="javascript:detail('${bean.GUUID}')" title="查看详细">
				<c:if test="${not empty bean.IMAGE}"><i id="iconIcon" class="icon-info-sign"></i></c:if>${bean['ITEM']}</a></td>
				<td>${bean['PLACE']}</td>
				<td>${fns:getDictLabel(bean['PAY_WAY'], 'BILL_PAY_WAY', '')}</td>
				<td title="${bean['REMARK']}">${fn:substring(bean['REMARK'],0,10)}</td>
				<td><a href="javascript:modify('${bean.GUUID}','修改账单记录')" title="修改"><i class="iconfont f16">&#xe619;</i></a>
				&nbsp;|&nbsp;<a href="javascript:del('${bean.GUUID}')" title="删除"><i class="iconfont f16">&#xe617;</i></a>
				&nbsp;|&nbsp;<a href="javascript:detail('${bean.GUUID}')" title="查看详细">
					<i class="iconfont f16">&#xe638;</i></a>
				</td>
				</tr>
			</c:forEach>
			<tr><td colspan="11" style="text-align:right;color:red;font-weight:bold;">
				总入账：${st3.income }&nbsp;&nbsp;&nbsp;&nbsp;总支出：${st3.outpay }&nbsp;&nbsp;&nbsp;&nbsp;</td></tr>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>