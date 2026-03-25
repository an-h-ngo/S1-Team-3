<%@ page import="java.sql.*"%>
<html>
	<head>
	  <title>YourSJSU</title>
	</head>
	<body>
	<h1>YourSJSU</h1>
	<form method="post" action="login.jsp">
		<table class="form-table">
		  <tbody>
		    <tr>
		      <td>
		        <label>SJSU Id Number</label>
		        <div class="id-wrap">
		        	<input class="field-input" type="id" id="id" name="id"/>
		        </div>
		      </td>
		    </tr>
		    <tr>
		      <td>
		        <label class="field-label" for="password">Password</label>
		        <div class="pw-wrap">
		          <input class="field-input" type="password" id="password" name="password"/>
		        </div>
		      </td>
		    </tr>
		    <tr>
		      <td>
		        <button>Enter</button>
		        <button>Forgot Password</button>
		      </td>
		    </tr>
		  </tbody>
		</table>
	 </form>
	 <%
	 	if (request.getMethod().equals("POST")) {
	        String id = request.getParameter("id");
	        String password = request.getParameter("password");
	        
	        if(id == ""){
	        	out.println("SJSU Id is missing");
	 		}
	        
	        else if (password == "") {
	        	out.println("Password is missing");
	        }
	        
	        else {
	        	
	        	int sjsuId;
	        	try {
		            sjsuId = Integer.parseInt(id);
		            out.println("The person has the id of:"+ id);
			        out.println("The person has the password of:"+ password);
		        } catch (NumberFormatException e) {
		        	out.println(e);
		        } catch (NullPointerException e) {
		        	out.println(e);
		        }
	        	
	        }
	        

	    }
	 %>
	</body>
</html>