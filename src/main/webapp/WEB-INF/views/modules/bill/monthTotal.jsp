<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>月账单统计</title>
<meta name="decorator" content="default" />
<%@include file="/WEB-INF/views/include/dialog.jsp"%>
<script type="text/javascript">
$(document).ready(function() {
	$(function () { $("[data-toggle='tooltip']").tooltip(); });	
});
function page(n, s) {
	$("#pageNo").val(n);
	$("#pageSize").val(s);
	$("#searchForm").attr("action", "${ctx}/report/monthTotal");
	$("#searchForm").submit();
	return false;
}
function monthDetail(month,type) {
	$("#month").val(month);
	if("" != type){$("#consumeType").val(type);}
	$("#detailForm").submit();
}
</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/report/monthTotal">月账单统计</a></li>
		<li><a href="javascript:void(0)">月账单详细</a></li>
	</ul>
	<tags:orgmessage content="${message}" />
	<form:form id="detailForm" modelAttribute="map" class="breadcrumb form-search" method="post"
		action="${ctx}/report/monthDetail" style="display:none;">
		<form:input path="bean['BLONG']"/>
		<form:input path="bean['CONSUME_TYPE']" id="consumeType"/>
		<form:input path="bean['LABEL']"/>
		<form:input path="bean['BEGIN_DATE']"/>
		<form:input path="bean['END_DATE']"/>
		<input id="month" name="bean['MONTH']" type="text"/>
	</form:form>
	<form:form id="searchForm" modelAttribute="map" class="breadcrumb form-search" method="post"
		action="${ctx}/report/monthTotal">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}" />
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}" />
		<table border="0">
			<tr>
				<td><label>消费人：</label></td>
				<td><tags:sysEmployeeSelect id="blong" name="bean[BLONG]" value="${map.bean.BLONG}" 
						labelName="bean[BLONG_NAME]" labelValue="${map.bean.BLONG_NAME}" checked="false"
						title="消费人" cssClass="" cssStyle="width:115px;"/></td>
				<td><label>收支类型：</label> 
					<form:select id="CONSUME_TYPE" path="bean['CONSUME_TYPE']" class="input-medium">
							<form:option value="">--请选择--</form:option>
							<form:options items="${fns:getDictList('BILL_IN_OUT_TYPE')}" 
							itemValue="value" itemLabel="label" htmlEscape="false"/>
						</form:select></td>
				<td><label>分类标签：</label> 
					<tags:treeselect id="LABEL" name="bean['LABEL']" value="${map.bean.LABEL}" 
					labelName="bean['LABEL_NAME']" labelValue="${map.bean.LABEL_NAME}" title="分类标签" 
					url="/bill/comm/treeData" extId="${map.bean.LABEL}" cssClass="input-small"/></td>
			</tr>
			<tr>
				<td><label>开始时间：</label></td>
				<td><input type="text" name="bean['BEGIN_DATE']" required="true" class="input-medium Wdate"  
				    value="${map.bean['BEGIN_DATE']}" 
				    onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" /></td>
				<td><label>结束时间：</label>
					<input type="text" name="bean['END_DATE']" required="true" class="input-medium Wdate"  
				    value="${map.bean['END_DATE']}" 
				    onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" /></td>
				<td align="right">
					&nbsp;&nbsp; <input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"
						onclick="return page();">
					<input id="btnCancel" class="btn btn-primary" type="button" value="重置"
						onclick="return page2();" />&nbsp;&nbsp; 
				</td>
			</tr>
		</table>
	</form:form>

	<table id="contentTable"
		class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>统计月份</th>
				<th>收入统计</th>
				<th>警戒值</th>
				<th>支出统计</th>
				<th>超出额</th>
				<th>合计</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${page.list}" var="bean">
			<tr>
				<td><a href="javascript:monthDetail('${bean.MONTH}','')">${bean['MONTH']}</a></td>
				<td><a href="javascript:monthDetail('${bean.MONTH}','1')">${bean['INCOME']}</a></td>
				<td>${bean['RED']}
				<c:if test="${not empty bean.REMARK }">
					<a href="javascript:void(0);" title="${bean['REMARK']}" data-toggle="tooltip">
						<i id="iconIcon" class="icon-info-sign"></i></a>
				</c:if></td>
				<c:choose> 
				  <c:when test="${bean.OUTCOST>bean.RED && bean.RED>0}">   
				  	<td>
					<a href="javascript:monthDetail('${bean.MONTH}','2')">
				    <span style="color:red;font-weight:bold;">${bean['OUTCOST']}</span>
				    </a></td>
				    <td>${bean.OUTCOST - bean.RED}
				    <c:if test="${not empty bean.EXPLAIN}">
				    	<a href="javascript:void(0);" title="${bean['EXPLAIN']}" data-toggle="tooltip">
						<i class="icon-info-sign"></i></a>
				    </c:if></td>
				  </c:when> 
				  <c:otherwise>   
				    <td><a href="javascript:monthDetail('${bean.MONTH}','2')">${bean['OUTCOST']} </a></td>
				    <td></td>
				  </c:otherwise> 
				</c:choose> 
				<td>${bean['TOTAL']}</td>
			</tr>
			</c:forEach>
			<tr style="font-weight:bold;">
				<td>月份数：${st3.RECORD }</td>
				<td>总收入:${st3.TOTAL_IN }<br>平均值:${st3.AVG_IN }</td>
				<td></td>
				<td>总支出:${st3.TOTAL_OUT }<br>平均值:${st3.AVG_OUT }<br>最高值:${st3.MAX_OUT }</td>
				<td>超支额:${st3.BEYOND }</td>
				<td>合计:${st3.TOTAL }</td>
			</tr>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>