<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*,com.xue.bbs.utils.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%!
	//递归函数，删除关联子帖
	public static void treeDelete(Connection con, int id, boolean isleaf) {
		//定义预编译处理类
		PreparedStatement pret = null;
		//定义返回结果集
		ResultSet rs = null;
		try {
			//编写sql删除语句
			String sql = "delete from article where id = ?";
			//预编译sql语句，此时还没执行
			pret = con.prepareStatement(sql);
			pret.setInt(1, id);
			pret.executeUpdate();
			
			//查看是否有子帖，有则递归删除，否则结束
			if (!isleaf) {
				sql = "select *from article where pid = ?";
				pret = con.prepareStatement(sql);
				pret.setInt(1, id);
				rs = pret.executeQuery();
				while (rs.next()) {
					//定值取值：帖子是否是叶子
					boolean isleaff = rs.getInt("isleaf") == 0 ? true : false;
					//取得帖子id
					int idd = rs.getInt("id");
					//递归删除
					treeDelete(con, idd, isleaff);
				}
			}
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			DBUtils.close(pret);
			DBUtils.close(rs);
		}
}


%>


<% 
	/*
	*此页面为删除帖子（树型）
	*/
	//验证session
	String str = (String)session.getAttribute("user");
	if (str != null && str.equals("success")) {
		//从主页帖子页面获取需要删除的帖子id 帖子的pid 帖子的isleaf
		int id = Integer.parseInt(request.getParameter("id") == null ? "-1" : request.getParameter("id"));
		int pid = Integer.parseInt(request.getParameter("pid") == null ? "-1" : request.getParameter("pid"));
		boolean isleaf = Boolean.parseBoolean(request.getParameter("isleaf"));
		//获取数据库连接
		Connection con = DBUtils.getConnection();
		//判断帖子信息
		if (id != -1 && pid != -1) {
			//递归删除子帖
			treeDelete(con, id, isleaf);
			
			//判断父贴是否还有子帖，有则不动，否则将isleaf改为0
			//定义预编译处理类
			PreparedStatement pret = null;
			//定义返回结果集
			ResultSet rs = null;
			try {
				//查询是否有帖子有一样的pid，下还有其它
				String sql = "select count(*) from article where pid = ?";
				pret = con.prepareStatement(sql);
				pret.setInt(1, pid);
				rs = pret.executeQuery();
				while (rs.next()) {
					//获取还有pid的总记录数
					int num = rs.getInt(1);
					out.println(num);
					//如果等于0,说明已经没有了，将叶子置为0
					if (num == 0) {
						sql = "update article set isleaf = ? where id = ?";
						pret = con.prepareStatement(sql);
						pret.setInt(1, 0);
						pret.setInt(2, pid);
						pret.executeUpdate();
					}
				}
			} catch(Exception e) {
				e.printStackTrace();
			} finally {
				DBUtils.close(con);
				DBUtils.close(pret);
				DBUtils.close(rs);
			}
		}
		
	} else {
		response.sendRedirect("err.jsp");
	}
%>
<html>

	<head>
	</head>
	<body>
		<span>删除成功</span>
		<span id="time" style="background:red">3</span>秒后自动跳转,如果不跳转请点击
		<script language="JavaScript1.2" type="text/javascript">
			function delayURL(url) {
				var delay = document.getElementById("time").innerHTML;
				//alert(delay);
				if(delay > 0) {
					delay--;
					document.getElementById("time").innerHTML = delay;
				} else {
					window.top.location.href = url;
				}
				//每隔一秒钟调用一次
				setTimeout("delayURL('" + url + "')", 1000);

			}
		</script>

		<a href="article.jsp">主题列表</a>

		<script type="text/javascript">
			delayURL("article.jsp");
		</script>
	</body>

</html>