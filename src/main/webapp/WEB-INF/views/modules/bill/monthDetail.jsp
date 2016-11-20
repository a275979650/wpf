<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>月账单详细</title>
<meta name="decorator" content="default" />
<%@include file="/WEB-INF/views/include/dialog.jsp"%>
<script type="text/javascript">
$(document).ready(function() {
	$(function () { $('#todoList').collapse('toggle')});
});
function page(n, s) {
	$("#pageNo").val(n);
	$("#pageSize").val(s);
	$("#searchForm").attr("action", "${ctx}/report/monthDetail");
	$("#searchForm").submit();
	return false;
}
function detail(guid) {
	top.$.jBox.open("iframe:${ctx}/bill/view?numId="+guid,"账单详细",800,450,{
		buttons : {"关闭" : true},
		submit : function(v, h, f) {
		},
		loaded : function(h) {
			$(".jbox-content", top.document).css("overflow-y", "hidden");
		}
	});
}
</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/report/monthTotal">月账单统计</a></li>
		<li class="active"><a href="javascript:void(0)">月账单详细</a></li>
	</ul>
	<tags:orgmessage content="${message}" />
	<form:form id="searchForm" modelAttribute="map" class="breadcrumb form-search" method="post"
		action="${ctx}/report/monthDetail">
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
					<tags:treeselect id="LABEL" name="bean['LABEL']" value="${map.bean.LABEL}" allowClear="true"
					labelName="bean['LABEL_NAME']" labelValue="${map.bean.LABEL_NAME}" title="分类标签" 
					url="/bill/comm/treeData" extId="${map.bean.LABEL}" cssClass="input-small" /></td>
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
				<td><label>统计月份：</label>
					<input type="text" name="bean['MONTH']" required="true" class="input-medium Wdate"  
				    value="${map.bean['MONTH']}" 
				    onclick="WdatePicker({dateFmt:'yyyy-MM',isShowClear:true});" />
				    &nbsp;&nbsp; <input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"
						onclick="return page();">
					<input id="btnCancel" class="btn btn-primary" type="button" value="重置"
						onclick="return page2();" />&nbsp;&nbsp; 
					<input id="btnCancel" class="btn btn-primary" type="button" value="返回"
						onclick="history.go(-1)" />&nbsp;&nbsp;
				</td>
			</tr>
		</table>
	</form:form>
<div class="tabbable">
  <ul class="nav nav-tabs">
      <li class="active">
      	<a href="#1" data-toggle="tab">账单详细</a>
      </li>
      <li>
      	<a href="#2" data-toggle="tab">分类统计</a>
      </li>
	</ul>
	<div class="tab-content">
		<div class="tab-pane active" id="1" style="border:solid 1px #CCCCCC">
	<table id="contentTable"
		class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>账单主体</th>
				<th>发生时间</th>
				<th>收支类型</th>
				<th>分类标签</th>
				<th>金额（元）</th>
				<th>账单内容</th>
				<th>交易地点</th>
				<th>支付方式</th>
				<th>备注</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${page.list}" var="bean">
				<tr>
				<td width="70px"><a href="javascript:detail('${bean.GUUID}')" title="查看详细">
					<i id="iconIcon" class="icon-info-sign"></i></a>${bean['BLONG_NAME']}</td>
				<td>${fns:formatDate(bean['CONSUME_TIME'], 'yyyy-MM-dd HH:mm:ss') }</td>
				<td>${fns:getDictLabel(bean['CONSUME_TYPE'], 'BILL_IN_OUT_TYPE', '')}</td>
				<td>${fns:getBillLabelBySeparator(bean['LABEL'], '', '')}</td>
				<td>${bean['AMOUNT']}</td>
				<td>${bean['ITEM']}</td>
				<td>${bean['PLACE']}</td>
				<td>${fns:getDictLabel(bean['PAY_WAY'], 'BILL_PAY_WAY', '')}</td>
				<td title="${bean['REMARK']}">${fn:substring(bean['REMARK'],0,10)}</td>
				</tr>
			</c:forEach>
			<tr><td colspan="11" style="text-align:right;color:red;font-weight:bold;">
				总入账：${st3.income }&nbsp;&nbsp;&nbsp;&nbsp;总支出：${st3.outpay }&nbsp;&nbsp;&nbsp;&nbsp;</td></tr>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
	</div>
		<div class="tab-pane" id="2">
			<table id="contentTable"
				class="table table-striped table-bordered table-condensed">
				<thead>
					<tr>
						<c:forEach items="${labelTotal}" var="labeln">
						<th>${labeln.LABEL_NAME}</th>
						</c:forEach>
					</tr>
				</thead>
				<tbody>
					<tr>
						<c:forEach items="${labelTotal}" var="labelV">
						<td>${labelV.TOTAL}</td>
						</c:forEach>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
</div>
</body>
</html>