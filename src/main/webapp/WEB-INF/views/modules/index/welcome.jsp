<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>欢迎首页</title>
<meta name="decorator" content="default" />
<%@include file="/WEB-INF/views/include/dialog.jsp" %>
<script type="text/javascript">
	$(document).ready(function() {
		$(function () { $('#todoList').collapse('toggle')});
	});
</script>
</head>
<body>
<tags:orgmessage content="${message}"/>
<div class="tabbable">
  <ul class="nav nav-tabs">
      <li class="active">
      	<a href="#1" data-toggle="tab">待办事项</a>
      </li>
      <li>
      	<a href="#2" data-toggle="tab">临时笔记</a>
      </li>
	</ul>
	<div class="tab-content">
		<div class="tab-pane active" id="1" style="border:solid 1px #CCCCCC">
			<div class="btn-info" data-toggle="collapse" data-target="#todoList">待办</div>
			<div id="todoList" class="panel-collapse collapse ">
				<ol>
					<li>港澳通行证签注办理【非广东户口需工作日预约柜面办理】</li>
					<li>端午回封开县火车票</li>
				</ol>
			</div>
		</div>
		<div class="tab-pane" id="2">
			<p>。。。。。。 </p>
		</div>
	</div>
</div>
</body>
</html>