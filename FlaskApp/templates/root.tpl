<!DOCTYPE html>
<html lang="en">
 
<head>
    <title>代码部署</title>
 
 
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="http://getbootstrap.com/examples/jumbotron-narrow/jumbotron-narrow.css" rel="stylesheet">
 
    <script src="../static/js/jquery-1.12.2.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>

 	{% block css_files %}
	{% endblock %}

	{% block header_js_files %}
	{% endblock %}
	
</head>
 
<body>
 
    <div class="container">
        <div class="header">
            <nav>
                <ul class="nav nav-pills pull-right">
                    <li role="presentation" class="active"><a href="/">首页</a>
                    </li>
                  
					
					{% if user %}
						<li role="presentation" class=""><a href="/userHome">个人</a>
						</li>
						<li role="presentation" class=""><a href="/logout">退出</a>
	                    </li>
	                    <li role="presentation"><a href="/showAddWish">添加仓库</a></li>
					{% else %}
					  <li role="presentation"><a href="showSignIn">登录</a>
	                    </li>
	                    <li role="presentation"><a href="showSignUp">注册</a>
	                    </li>
				    {% endif %}
					
                </ul>
            </nav>
            <h3 class="text-muted">代码部署</h3>
        </div>
 
            {% block content %}
		    {% endblock %}
 
        
        <footer class="footer">
            <p>&copy; SMM 2016</p>
        </footer>
 
    </div>
	
    {% block footer_js_files %}
	{% endblock %}
	
	
</body>
 
</html>