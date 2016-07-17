 $(function(){
			function listCommits(e, projectId) {
				 $.ajax({
	                url : '/list_commits?project_id='+projectId,
	                type : 'GET',
	                success: function(res){
	                  
		                    var data = JSON.parse(res);
	
		                    $.each(data.data.infos,function(index, value){
		                        	e.append(
									$("<option>").html("版本1")
										.attr(
											"data-content",
											"<span class='commit-name'>" + value.name + "</span><br> " + value.id + "<br>" + value.datetime
											)
										.attr(
											"value",
											value.id
											)
							    	)
	
		                    })
						    e.selectpicker();
						    e.val(data.data.current).trigger('change');
							 
					}
				})
			}
			
			function DeployVersion(projectId, version, callback) {
				 postData = {
					"project_id": projectId,
					"current": version
				}
				 $.ajax({
	                url : '/deploy_project',
	                type : 'POST',
				    data: postData,
	                success: function(res){
		                var data = JSON.parse(res);
		                alert(data.msg)
					    callback();
					}
				})
			}
			
			
            $.ajax({
                url : '/get_project_list',
                type : 'GET',
                success: function(res){
                    var tr = $('<tr>')
					
        		.append($('<td>').attr('class', 'id'));
            tr.append($('<td>').attr('class', 'name'));
			tr.append($('<td>').attr('class', 'title'));
			tr.append($('<td>').attr('class', 'link'));
		    tr.append($('<td>').attr('class', 'description'));
			tr.append($('<td>').attr('class', 'current'));
				tr.append($('<td>').append($('<span>').attr('class', 'action-btn'))
			
			);
                                    
                    
                    
                    var wishObj = JSON.parse(res);
                    var wish = '';
                    
                    $.each(wishObj,function(index, value){
                        wish = $(tr).clone();
                        $(wish).find('td.id').text(value.id);
						$(wish).find('td.name').text(value.name);
						$(wish).find('td.link').text(value.link);
                        $(wish).find('td.title').text(value.title);
						$(wish).find('td.description').text(value.description);
						$(wish).find('td.current').text(value.current);
						$(wish).find('.action-btn').text("发布");
                        $('.deploy-rows').append(wish);
                    });

					$(".action-btn").click(function() {
						btn = this;
						BootstrapDialog.show({
				            title: $(this).parent().parent().find("td.name").html() + '发布代码',
				            message: function(dialog) {
							   current = $(btn).parent().parent().find("td.current").html();

				                var $content = $('<div>当前版本：' + current +'</div>');
				                var $footerButton = dialog.getButton('btn-deploy');
//				                dialog.getButton('btn-stop').click({$footerButton: $footerButton}, function(event) {
//				                    event.data.$footerButton.enable();
//				                    event.data.$footerButton.stopSpin();
//				                    dialog.setClosable(true);
//				                });
								$content.append($("<br>"));
								
								var $select = $('<select class="selectpicker"></select>')
								
								projectId = $(btn).parent().parent().find("td.id").html();
								if (projectId=="") {
									return alert("请选择项目")
								}
								
								listCommits($select, projectId);
								//setTimeout(function() {$select.selectpicker();}, 500)
								$content.append($select);
				                return $content;
				            },
				            buttons: [
							{
				                id: 'btn-deploy',
				                label: '确认发布',
				                action: function(dialog) {
									window.dialog = dialog;
				                    var $button = this; // 'this' here is a jQuery object that wrapping the <button> DOM element.
									projectId = $(btn).parent().parent().find("td.id").html();
									current = $(".selectpicker").val();
									$button.disable();
				                    $button.spin();
				                    dialog.setClosable(false);
									
									DeployVersion(projectId, current, function (){
										$button.enable();
					                     $button.stopSpin();
					                     dialog.setClosable(true);
										dialog.close();
									});
				                    
				                }
				            }]
				        });
					});
			
                },
                error: function(error){
                    console.log(error);
                }
            });
		
        });