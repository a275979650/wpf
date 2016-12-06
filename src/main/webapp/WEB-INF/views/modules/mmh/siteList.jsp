<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>站点列表</title>
<meta name="decorator" content="default" />
<script type="text/javascript">
	$(document).ready(function() {
		$("#tableHead").click(function() {
			if ($(this).attr("checked")) {
				$("#contentTable tbody :checkbox[name='rowSelect']").attr("checked", true);
				} else {
					$("#contentTable tbody :checkbox[name='rowSelect']").attr("checked", false);
				}
		});

});
function page(n, s) {
	$("#pageNo").val(n);
	$("#pageSize").val(s);
	$("#searchForm").attr("action", "${ctx}/mmh/site/list");
	$("#searchForm").submit();
	return false;
}
function reload() {
	window.location.href = "${ctx}/mmh/site/list";
}
function modify(guid){
	window.location.href="${ctx}/mmh/site/form?id="+guid;
}
function del(guid){
	top.$.jBox.confirm("确认删除站点信息吗？",'系统提示',function(v,h,f){
		   if(v=='ok'){
	    		$("#searchForm").attr("action","${ctx}/mmh/site/delete?id="+guid);
	    		$("#searchForm").submit();
		   }
		},{buttonsFocus:1});
 	top.$('.jbox-body .jbox-icon').css('top','55px');
}

function detail(guid,siteName) {
	var index = layer.open({
		type: 2,
		area: ['700px', '350px'],
		maxmin: true,
		title: siteName,
		content: '${ctx}/mmh/account/list?siteId='+guid
	});
	layer.full(index);
}
</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/mmh/site/list">站点管理列表</a></li>
		<li><a href="${ctx}/mmh/site/form">添加站点</a></li>
	</ul>
	<div style="display:none;"><tags:orgmessage content="${message}" /></div>
	<form:form id="searchForm" modelAttribute="map" class="breadcrumb form-search" method="post"
		action="${ctx}/mmh/site/list">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}" />
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}" />
		<table border="0">
			<tr>
				<td><label>站点类型：</label></td>
				<td><form:select path="bean['TYPE']" class="input-small">
						<form:option value="" label=""/>
						<form:options items="${fns:getDictList('MMH_SITE_TYPE')}" 
							itemValue="value" itemLabel="label" htmlEscape="false"/>
					</form:select></td>
				<td><label>分类标签：</label> </td>
				<td><tags:treeselect id="TAGLIB" name="bean['TAGLIB']" value="${map.bean.TAGLIB}" 
					labelName="bean['TAGLIB_NAME']" labelValue="${map.bean.TAGLIB_NAME}" title="分类标签" 
					url="/bill/comm/treeData" extId="${map.bean.TAGLIB}" allowClear="true" cssStyle="width:82px;"/>
				</td>
				<td><label>名称：</label></td>
				<td><form:input path="bean['NAME']" htmlEscape="false"
						maxlength="32" class="input-small" /></td>
				<td>
					&nbsp;&nbsp; <input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"
						onclick="return page();">
					<input id="btnCancel" class="btn btn-primary" type="button" value="重置"
						onclick="return reload();" />
				</td>
			</tr>
		</table>
	</form:form>
	<table id="contentTable"
		class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th width="12px"><input type="checkbox" id="tableHead"></th>
				<th width="120px">类型</th>
				<th>名称</th>
				<th>URL</th>
				<th>简介</th>
				<th>创建时间</th>
				<th>备注</th>
				<th width="100px">操作</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${page.list}" var="bean">
				<tr>
				<td><input type="checkbox" name="rowSelect"
					value="${bean['ID']}" /></td>
				<td>${fns:getDictLabel(bean['TYPE'], 'MMH_SITE_TYPE', '')}</td>
				<td>${bean['NAME']}</td>
				<td>${bean['URL']}</td>
				<td title="${bean['EXPLAIN']}">${fn:substring(bean['EXPLAIN'],0,30)}</td>
				<td>${fns:formatDate(bean['CREATE_TIME'], 'yyyy-MM-dd HH:mm:ss') }</td>
				<td title="${bean['REMARK']}">${fn:substring(bean['REMARK'],0,10)}</td>
				<td><a href="javascript:modify('${bean.ID}')">修改</a>
				&nbsp;|&nbsp;<a href="javascript:del('${bean.ID}')">删除</a>
				&nbsp;<a href="javascript:detail('${bean.ID}','${bean.NAME }')" title="查看详细">
					<i id="iconIcon" class="icon-info-sign"></i></a>
				</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>