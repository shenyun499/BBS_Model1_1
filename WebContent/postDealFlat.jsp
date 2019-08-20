<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*,com.xue.bbs.utils.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	/*
	*此页面为发布主题帖（平板）
	*/
	//设置字符编码
	request.setCharacterEncoding("utf-8");
	//从发布帖子页面获取帖子信息
	String title = request.getParameter("title");	
	String cont = request.getParameter("cont");
	
	//验证session
	String str = (String)session.getAttribute("user");
	if (str != null && str.equals("success")) {
		//判断帖子信息
		if (title != null && cont != null && title != "" && cont != "") {
			//定义预编译处理类
			PreparedStatement pret = null;
			//定义返回结果集
			ResultSet rs = null;
			//定义数据库连接
			Connection con = null;
			try {
				//获取数据库连接
				con = DBUtils.getConnection();
				//将自动提交事务，改成手动提交
				con.setAutoCommit(false);
				//编写sql插入语句
				String sql = "INSERT INTO `bbs`.`article` (`pid`, `rootid`, `title`, `cont`, `pdate`, `isleaf`) VALUES (?,?, ?, ?, now(), ?)";
				//预编译sql语句，此时还没执行
				pret = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
				//设置插入条件
				pret.setInt(1, 0);
				//因为不确定id，所以，先插入一个数，随后在update
				pret.setInt(2, 0);
				pret.setString(3, title);
				pret.setString(4, cont);
				pret.setInt(5, 0);
				//执行sql语句，插入，插入成功返回受影响的行数
				int num = pret.executeUpdate();
				//num为1，插入成功
				if (num == 1) {
					//根据插入成功，获取id
					int id;
					rs = pret.getGeneratedKeys();
					while (rs.next()) {
						id = rs.getInt(1);
						//获取id后，插入rootid
						sql = "update article set rootid = ? where id = ?";
						//预编译
						pret = con.prepareStatement(sql);
						//设置插入条件
						pret.setInt(1, id);
						pret.setInt(2, id);
						//执行插入
						pret.executeUpdate();
						con.commit();
						con.setAutoCommit(true);
					}
				} else {
					//添加失败
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

		<body>
			<span id="time" style="background:red">3</span>
			<p>秒后自动跳转,如果不跳转请点击</p>
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

			<script type="text/javascript">
				delayURL("articleFlat.jsp");
			</script>
			<p>发表主题成功!</p><br>
			<a href="articleFlat.jsp">点击返回主论坛</a>
		</body>

</html>