<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>基本信息查询</title>
<meta name="decorator" content="default" />
<%@include file="/WEB-INF/views/include/dialog.jsp"%>
<style type="text/css">
.sort {
	color: #0663A2;
	cursor: pointer;
}
</style>
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

			$.jBox.confirm("确认批量导出基本信息吗？", "提示", submit);

		});
});
function page(n, s) {
	$("#pageNo").val(n);
	$("#pageSize").val(s);
	$("#searchForm").attr("action", "${ctx}/demo/list");
	$("#searchForm").submit();
	return false;
}
function page2(n, s) {
	$("#pageNo").val(n);
	$("#pageSize").val(s);
	$("#SID").val("");
	$("#NAME").val("");
	$("#STAFF_SORT").val("");
	$("#DEPT_IDId").val("");
	$("#DEPT_IDName").val("");
	$("#searchForm").attr("action", "${ctx}/demo/list");
	$("#searchForm").submit();
	return false;
}

function confirmy(mess, href) {
	top.$.jBox.confirm(mess, '系统提示', function(v, h, f) {
		if (v == 'ok') {
			location = href;
		}
	}, {
		buttonsFocus : 1
	});
	top.$('.jbox-body .jbox-icon').css('top', '55px');
	return false;
}
function importData() {
	top.$.jBox.open("iframe:${ctx}/comm/import/index?dicId=T_COMM_BASE_INFO","基本工资导入",550,450,{
		buttons : {"关闭" : true},
		submit : function(v, h, f) {
			window.location.href = "${ctx}/demo/list";
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
	<ul class="nav nav-tabs">
		<li class="active"><a
			href="${ctx}/demo/list">基本信息查询</a></li>
	</ul>
	<div style="display: none;">
		<tags:orgmessage content="${message}" />
	</div>
	<form:form id="exportForm" modelAttribute="map"
		class="breadcrumb form-search" method="post" style="display:none;" action="${ctx}/demo/export">
		<input type="hidden" name="bean['SID']" value="${map.bean['SID'] }">
		<input type="hidden" name="bean['DEPT_ID']" value="${map.bean['DEPT_ID'] }">
		<input type="hidden" name="bean['STAFF_SORT']" value="${map.bean['STAFF_SORT'] }">
	</form:form>
	<form:form id="searchForm" modelAttribute="map" class="breadcrumb form-search" method="post"
		action="${ctx}/demo/list">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}" />
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}" />
		<table border="0">
			<tr>
				<td><label>SID/姓名：</label></td>
				<td><form:input id="SID" path="bean['SID']" htmlEscape="false"
						maxlength="32" class="input-small" /></td>
				<td><label>所在单位：</label> 
					<tags:treeselect id="DEPT_ID" name="bean['DEPT_ID']" value="${map.bean.DEPT_ID}"
						labelName="bean['DEPT_NAME']" labelValue="${map.bean.DEPT_NAME}"
						title="所在部门" url="/sys/office/treeData?type=2"
						cssClass="input-small" allowClear="true" /></td>
				<td><label>人员类别：</label> 
					<form:select id="STAFF_SORT" path="bean['STAFF_SORT']" style="width:135px;">
						<option value="">--请选择--</option>
						<form:options items="${fns:getDictList('HR_SUSTC_STAFF_SORT')}"
							itemValue="value" itemLabel="label" htmlEscape="false" />
					</form:select></td>
				<td>
					&nbsp;&nbsp; <input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"
						onclick="return page();">
					<input id="btnCancel" class="btn btn-primary" type="button" value="重置"
						onclick="return page2();" />&nbsp;&nbsp; 
					<input class="btnImpAndExp  btn-primaryImpAndExp" type="button" value="导入"
						onclick="importData();">&nbsp;&nbsp; 
					<input id="export" class="btnImpAndExp btn-primaryImpAndExp" type="button" value="导出">
				</td>
			</tr>
		</table>
	</form:form>

	<table id="contentTable"
		class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th width="12px"><input type="checkbox" id="tableHead"></th>
				<th>姓名</th>
				<th>SID</th>
				<th>证件号码</th>
				<th>所在单位</th>
				<th>人员状态</th>
				<th>人员类别</th>
				<th>岗位名称</th>
				<th>工作时间</th>
				<th>进校时间</th>
				<th>毕业学校</th>
				<th>联系电话</th>
				<th>邮箱</th>
		</thead>
		<tbody>
			<c:forEach items="${page.list}" var="bean">

				<td><input type="checkbox" name="rowSelect"
					value="${bean['SID']}" /></td>
				<td width="70px">${bean['NAME']}</td>
				<td>${bean['SID']}</td>
				<td>${bean['ID_CODE']}</td>
				<td>${fns:getOfficeLabelBySeparator(bean['DEPT_ID'], '','')}</td>
				<td>${fns:getDictLabel(bean['status'], 'HR_STF_STATUS', '')}</td>
				<td>${fns:getDictLabel(bean['STAFF_SORT'], 'HR_SUSTC_STAFF_SORT', '')}</td>
				<td>${bean['POST_NAME']}</td>
				<td><fmt:formatDate value="${bean.WORK_DATE}" /></td>
				<td><fmt:formatDate value="${bean.INSCHOOL_DATE}" /></td>
				<td>${bean['HIGH_SCH']}</td>
				<td>${bean['MOBILE_PHONE']}</td>
				<td title="${bean['EMAIL']}">${fns:abbr(bean['EMAIL'],50)}</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>