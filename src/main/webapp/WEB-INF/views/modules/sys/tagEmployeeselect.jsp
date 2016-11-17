<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html style="overflow-x:hidden;overflow-y:auto;">
<head>
	<title>数据选择</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	
	$(document).ready(function() {
		var check = '${checked}';
		if(check){
	        //复选框实现单选
	        $("#contentTable tbody :checkbox").each(function(){
	        		$(this).click(function(){
		       			 if($(this).attr("checked")){
		       			 	$("#contentTable tbody :checkbox").removeAttr('checked');
		       			 	$(this).attr('checked','checked'); 
			       			 $("#contentTable tbody :checkbox").each(function(){
					            	selectFunction(this);
					            });
		       			 }else{
		 					$("#contentTable tbody :checkbox").attr("checked", false);  
							$("#contentTable tbody :checkbox").each(function(){
				            	selectFunction(this);
				            });
						}
	       			});
			});
		}else{
			$("#tableHead").click(function () {
				if($(this).attr("checked")){
		            $("#contentTable tbody :checkbox").attr("checked", true);  
		            $("#contentTable tbody :checkbox").each(function(){
		            	selectFunction(this);
		            });
				}else{
					$("#contentTable tbody :checkbox").attr("checked", false);  
					$("#contentTable tbody :checkbox").each(function(){
		            	selectFunction(this);
		            });
				}
	        }); 
		}
		
 
			var employeeSelected2 = null;
			var	employeeNameSelected2 = null;
			if(top.mainFrame.reviewMainFrame){
				employeeSelected2 = top.mainFrame.reviewMainFrame.employeeSelected2;
				employeeNameSelected2 = top.mainFrame.reviewMainFrame.employeeNameSelected2;
			}else{
				employeeSelected2 = parent.employeeSelected2;
				employeeNameSelected2 = parent.employeeNameSelected2;
				//employeeSelected2 = top.mainFrame.employeeSelected2;
				//employeeNameSelected2 = top.mainFrame.employeeNameSelected2;
			}
			var isAll = true;
			$("input[name=rowSelect]").each(function(t){
				for (var i=0,len=employeeSelected2.length; i<len; i++){
					if (employeeSelected2[i]==$(this).val()){
						//this.checked = true;
					}
				}
				$(this).click(function(){
					selectFunction(this);
					if(allSelectFunction()){
						$("#tableHead").attr("checked", true);  
					}else{
						$("#tableHead").attr("checked", false);  
					}
				});
			});
			var allSelectFunction = function(){
				var isAll = true;
				 $("#contentTable tbody :checkbox").each(function(){
					 if(!this.checked){
							isAll = false;
					}
		         });
				return isAll;
			};
			var selectFunction =  function(obj){
				var checked =obj.checked;
				var isExists = false;
				var index = null;
				for (var i=0,len=employeeSelected2.length; i<len; i++){
					if (employeeSelected2[i]==$(obj).val()){
						isExists = true;
						index = i;
						break;
					}
				}
				if(checked){
					if(!isExists){
						if(${checked}){
							employeeSelected2.push($(obj).val());
							employeeNameSelected2.push(getValueByJson(obj,"name"));
						}else{
							employeeSelected2[0]=$(obj).val();
							employeeNameSelected2[0]=getValueByJson(obj,"name");
						}
					}
				}else{
					if(isExists){
						remove(employeeSelected2,index);
						remove(employeeNameSelected2,index);
					}
				}
			};
			var getValueByJson = function(obj,key){
				var json = $(obj).attr("json");
				var ojson = $.parseJSON(json.replace(new RegExp("'","gm"),"\""));
				return ojson[key];
			};
			if(allSelectFunction()){
				$("#tableHead").attr("checked", true);  
			};
	});
	function remove(a,dx){
		if(dx>a.length){
			return false;
	  	 }
		for(var i=0,n=0,len=a.length;i<len;i++){
			if(a[i]!=a[dx]){
				a[n++]=a[i]
			}
		}
			a.length-=1;
	};
	function page(n,s){
		$("#pageNo").val(n);
		$("#pageSize").val(s);
		$("#searchForm").attr("action","${ctx}/sys/empSelect/listEmployee?checked=${checked}&sortValue=${value}");
		$("#searchForm").submit();
    	return false;
    };
	</script>
</head>
<body>
	<form:form id="searchForm" modelAttribute="map" action="${ctx}/sys/empSelect/listEmployee?checked=${checked}&sortValue=${value}" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<input id="orderBy" name="orderBy" type="hidden" value="${page.orderBy}"/>
		<div style="margin-top:8px;">
			<label>姓名/编号 ：</label>
			<form:input path="bean['NAME']" htmlEscape="false" maxlength="100" class="input-small"/>&nbsp;
			<label>所在单位：</label>
			<tags:treeselect id="DEPT_ID" name="bean['DEPT_ID']" value="${map.bean['DEPT_ID']}" 
				labelName="DEPT_ID_NAME" labelValue="${fns:getOfficeLabelBySeparator(map.bean['DEPT_ID'], '','')}" 
				title="所在部门" url="/sys/office/treeData?type=2" cssClass="input-small" allowClear="true"/>
			&nbsp;<input id="btnSubmit" class="btn btn-primary" type="submit" value="查询" onclick="return page();"/>
		</div>
	</form:form>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
					<th><input type="checkbox" id="tableHead"></th>
				<th>人事编号</th>
				<th>姓名</th>
				<th>状态</th>
				<th>部门</th>
				<th>职务</th>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="bean">
			<tr>
				<c:choose>
					<c:when test="${bean.CH eq '1'}">
					<td><input checked="checked" type="checkbox" name="rowSelect" value="${bean.EMPLOYEE_ID}" json="{'name':'${bean.NAME}','deptName':'${bean.DEPT_NAME}'}"></td>
					</c:when>
					<c:otherwise>
					<td><input type="checkbox" name="rowSelect" value="${bean.EMPLOYEE_ID}" json="{'name':'${bean.NAME}','deptName':'${bean.DEPT_NAME}'}"></td>					
					</c:otherwise>
				</c:choose>
				
				<td >${bean.EMPLOYEE_ID}</td>
				<td>${bean.NAME}</td>
				<td>${fns:getDictLabel(bean['STATUS'], 'HR_STF_STATUS', '')}</td>
				<td>${bean.DEPT_NAME}</td>
				<td>${bean.DUTY}</td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
		<div class="pagination">${page}</div>
</body>