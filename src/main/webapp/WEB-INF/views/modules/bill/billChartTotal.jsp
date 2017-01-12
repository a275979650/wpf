<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>月账单统计</title>
<meta name="decorator" content="default" />
<%@include file="/WEB-INF/views/include/dialog.jsp"%>
<script src="${ctxStatic}/echarts/echarts.min.js"></script>
<script type="text/javascript">
$(document).ready(function() {
	//基于准备好的dom，初始化echarts实例
	var myChart = echarts.init(document.getElementById('monthTotal'));
    // 指定图表的配置项和数据
    var option = {
    		title: {
                text: '月账单统计情况',
                subtext:'月单详细',
                sublink:'${ctx}/report/monthTotal',
                subtarget:'blank'
            },
            tooltip: {
    	        trigger: 'axis',
    	        axisPointer : {            // 坐标轴指示器，坐标轴触发有效
    	            type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
    	        }
    	    },
    	    toolbox: {
    	        feature: {
    	            dataView: {show: true, readOnly: false},
    	            magicType: {show: true, type: ['line', 'bar']},
    	            restore: {show: true},
    	            saveAsImage: {show: true}
    	        }
    	    },
    	    legend: {
    	        data:['收入','支出','结余'],itemGap: 5
    	    },
    	    grid:{left:60},
    	    xAxis: [
    	        {
    	            type: 'category',
    	            scale: true,
    	            data: []
    	        }
    	    ],
    	    yAxis: [
    	        {
    	            type: 'value',
    	            name: '',
    	            axisLabel: {
    	                formatter: '{value} '
    	            }
    	        },
    	        {
    	            type: 'value',
    	            name: '金额(￥)',
    	            axisLabel: {
    	                formatter: '{value} '
    	            }
    	        }
    	    ],
    	    dataZoom: [
               {
                   type: 'slider',
                   show: true,
                   start: 50,
                   end: 100,
                   handleSize: 8
               },
               {
                   type: 'inside'
               },
               {
                   type: 'slider',
                   show: true,
                   yAxisIndex: 0,
                   filterMode: 'empty',
                   width:60,
                   handleSize: 8,
                   left: '0'
               }
           ],
    	    series: [
    	        {
    	            name:'收入',
    	            type:'bar',
    	            label:{normal:{show:true,position:'top',
    	            	formatter: function(c){return Math.round(c.value/1000);}}},
    	            //itemStyle:{normal:{color:'green'}},
    	            data: []
    	        },
    	        {
    	            name:'支出',
    	            type:'bar',
    	            label:{normal:{show:true,position:'top',
    	            	formatter: function(c){return Math.round(c.value/1000);}}},
   	            	markPoint : {
   	                    data : [
   	                        {type : 'max', name: '最大值'},
   	                        {type : 'min', name: '最小值'}
   	                    ],
	   	                label:{normal:{show:true,position:'insideTop',
	     	            	formatter: function(c){return Math.round(c.value/1000)+"k";}}}
   	                },
   	                markLine : {
   	                    data : [
   	                        {type : 'average', name: '平均值'}
   	                    ]
   	                },
    	            //itemStyle:{normal:{color:'red'}},
    	            data: []
    	        },
    	        {
    	            name:'结余',
    	            type:'line',
    	            data: [],
    	            label:{normal:{show:true,position:'top',
    	            	formatter: function(c){return Math.round(c.value/1000);}}},
   	            	markLine : {
      	                data : [
      	                      {name: '平衡线',yAxis: 0,lineStyle:{normal:{color:'red'}}}
      	                ]
      	            },
    	            smooth:true,
    	            //itemStyle:{normal:{color:'blue'}},
    	            yAxisIndex: 1
    	        }
    	    ]
    };
 	// 使用刚指定的配置项和数据显示图表。
    myChart.setOption(option);
    getData(myChart);
    
    $("#btnSubmit").click(function(){
    	getData(myChart);
    });
    
});
function getData(barChart){
	// 异步加载数据
    $.get('${ctx}/bill/chart/monthTotalData',$("#searchForm").serialize()).done(function (data) {
        // 填入数据
        barChart.setOption({
            xAxis: {data: data.xData},
            series: [{name: '收入',data: data.yIncomeData},
                     {name: '支出',data: data.yOutData},
                     {name: '结余',data: data.ySubData}],
            dataZoom: [{startValue: data.xStartValue,endValue: data.xEndValue},
                       {startValue: data.xStartValue,endValue: data.xEndValue},
                       {startValue: 0,endValue: data.yEndValue}]
        });
    });
};
</script>
</head>
<body>
	<form:form id="searchForm" modelAttribute="map" class="breadcrumb form-search" method="post"
		action="${ctx}/bill/list">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}" />
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}" />
		<table border="0">
			<tr>
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
				<td><label>统计范围：</label></td>
				<td><form:select path="bean['NOT_STATISTICS']" class="input-small" >
							<form:option value="" label="---请选择---"/>
							<form:option value="0" label="参与统计"/>
							<form:option value="1" label="不参与统计"/>
						</form:select></td>
			</tr>
			<tr>
				<td><label>消费人：</label></td>
				<td><tags:sysEmployeeSelect id="blong" name="bean[BLONG]" value="${map.bean.BLONG}" 
						labelName="bean[BLONG_NAME]" labelValue="${map.bean.BLONG_NAME}" checked="false"
						title="消费人" cssClass="" cssStyle="width:115px;"/></td>
				<td><label>支付方式：</label></td>
				<td><form:select path="bean['PAY_WAY']" class="input-small" >
							<form:option value="" label="---请选择---"/>
							<form:options items="${fns:getDictList('BILL_PAY_WAY')}" 
							itemValue="value" itemLabel="label" htmlEscape="false"/>
						</form:select></td>
				<td>&nbsp;&nbsp; 
					<input id="btnSubmit" class="btn btn-primary" type="button" value="分析" >
					<input id="btnClear" class="btn btn-primary" type="button" value="重置" />
				</td>
			</tr>
		</table>
	</form:form>
	<div id="monthTotal" style="width: 100%;height:400px;"></div>
</body>
</html>