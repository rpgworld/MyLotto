<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maxmun-scale=1, minimun-scale=1, user-scalable=no">
<title>Lotto World</title>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/bxslider/4.2.12/jquery.bxslider.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script	src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
<script src="https://cdn.jsdelivr.net/bxslider/4.2.12/jquery.bxslider.min.js"></script>
<style>
@import url(http://fonts.googleapis.com/earlyaccess/hanna.css);

* {
font-family: 'Hanna', serif;
}

/* 모바일용 css */
/* 기본 css */
#lotto_head {
display: flex;
flex-flow: column;
justify-content: space-between;
}
#lotto_head input{
margin-right: 10px;
}
#lotto_head div:first-child {
order: 2;
}
#date {
order: 1;
text-align: right;
}
#count {
width: 150px;
}
#lotto_body {
display: flex;
flex-flow: column;
}
#lotto_body div {
margin-right: 10px;
}
#lotto_body .plus {
margin-top: 1%;
font-size: 2rem;
text-align: center;
}
#lotto_body label {
font-size: 0.8rem;
font-size: 0.8em;
}
#lotto_btns {
display: flex;
justify-content: flex-end;
}
#lotto_btns input{
margin-left: 6px;
}
/* 푸터 css */
.footer {
width: 100%;
background: #474747;
margin-top: 30px;
}
.footer p {
padding: 20px;
padding: 1.250rem;
font-size: 0.813em;
font-size: 0.813rem;
text-align: center;
text-transform: uppercase;
font-weight: bold;
color: #fff;
text-shadow: 0px 1px 1px #191919;
}

/* 태블릿용 css */
@media all and (min-width: 768px) {
#lotto_head {
flex-flow: row;
}
#lotto_head div:first-child, #date {
order: 0; /* 배치 초기화 */
}

#lotto_head input {
width: auto;
}
#lotto_body {
flex-flow: row;
justify-content: space-between;
align-items: center;
}
#lotto_body div {
padding-right: 0px;
width: 100%;
}
#lotto_body .plus {
width: 20%;
}
}

/* PC 용 css */
@media all and (min-width: 960px) {

}
</style>
<script>
$('document').ready(function(){
	// 최신 회차 구하기
	var today = new Date();
	var stdDate = new Date('2019/05/25');
	var std = 860;
	var diff = (today - stdDate) / (24 * 60 * 60 * 1000);
	std = std + Math.floor(diff/7);
	$.ajax({
		type: 'get',
		dataType: 'json',
		url: '/MyLotto/LottoNumber',
		data: {count: std},
		success: function(result) {
	    	var num1 = result.drwtNo1;
	    	var num2 = result.drwtNo2;
	    	var num3 = result.drwtNo3;
	    	var num4 = result.drwtNo4;
	    	var num5 = result.drwtNo5;
	    	var num6 = result.drwtNo6;
	    	var bnum = result.bnusNo;
	    	$('#header #info').append('최신 회차 날짜 : ' + result.drwNoDate + '<br>');
	    	$('#header #info').append('당첨 번호 : ' + num1 + ' ' + num2 + ' ' + num3 + ' ' + num4 + ' ' 
	    			+ num5 + ' ' + num6 + ' + ' + bnum);
	        
	    },
	    error: function (request,status, error) {
	        console.log(error);
	        alert(status);
	    }
	});
	

	// 해당 회차 번호 가져오기
	$('#getNumber').click(function(){
		var count = $('#count').val();
		$.ajax({
			type: 'GET',
		    dataType: 'json',
		    url: '/MyLotto/LottoNumber',
		    data: {count: count},
		    success: function(result) {
		    	$('#number1').val(result.drwtNo1);
		    	$('#number2').val(result.drwtNo2);
		    	$('#number3').val(result.drwtNo3);
		    	$('#number4').val(result.drwtNo4);
		    	$('#number5').val(result.drwtNo5);
		    	$('#number6').val(result.drwtNo6);
		    	$('#bnusNo').val(result.bnusNo);
		    	$('#date').html('해당 회차 날짜 : ' + result.drwNoDate);
		        
		    },
		    error: function (request,status, error) {
		        console.log(error);
		        alert(status);
		    }
		});
	});
	// 초기화
	$('#resetAll').click(function(){
		$('input[type=\'text\']').val('');
	});
	// 로또 번호 등수 확인
	$('#gogo').click(function(){
		var count = $('#count').val();
		
		var inputNumber = new Array();
		
		inputNumber[0] = $('#number1').val();
    	inputNumber[1] = $('#number2').val();
    	inputNumber[2] = $('#number3').val();
    	inputNumber[3] = $('#number4').val();
    	inputNumber[4] = $('#number5').val();
    	inputNumber[5] = $('#number6').val();
    	
    	// 입력한 로또번호 오름차순
    	for(var i = 0; i < 6; i++) {
    		for(var j = 0; j < 6 - i - 1; j++) {
    			if(inputNumber[j] < inputNumber[j+1]) {
    				var temp = inputNumber[j];
    				inputNumber[j] = inputNumber[j+1];
    				inputNumber[j] = temp;
    			}
    		}
    	}
		
		// 회차 입력
		if (count == "") {
			$('#myModalLabel').html('경고창');
			$('.modal-body').html('회차를 입력하세요.');
			$('#myModal').modal();
			return;
		} 
		// 번호 빈칸 확인
		for(var i = 0; i < 6; i++) {
			if(inputNumber[i] == "") {
				$('#myModalLabel').html('경고창');
				$('.modal-body').html('번호를 입력하세오.');
				$('#myModal').modal();
				return;
			}
		}
		// 1 ~ 45 의 숫자
		for(var i = 0; i < 6; i++) {
			if(inputNumber[i] < 1 || inputNumber[i] > 45) {
				$('#myModalLabel').html('경고창');
				$('.modal-body').html('1 ~ 45 의 숫자를 입력하세요.');
				$('#myModal').modal();
				return;
			}
		}
		// 번호 중복이 없도록
		for (var i = 0; i < 6; i++) {
        	for (var j = 0; j < 6; j++) {
        		if (inputNumber[i] == inputNumber[j]) {
        			if(i == j) continue;
        			$('#myModalLabel').html('경고창');
					$('.modal-body').html('중복된 번호가 있습니다.');
					$('#myModal').modal();
					return;
        		}
        	}
        }
		
		$.ajax({
			type: 'GET',
		    dataType: 'json',
		    url: '/MyLotto/LottoNumber',
		    data: {"count": count},
		    success: function(result) {
		    	var lottoNumber = new Array();
		    	var correct = 0; // 몇개 맞았는지 카운트
		    	var msg; // 당첨 메시지
		    	
		    	lottoNumber[0] = result.drwtNo1;
		    	lottoNumber[1] = result.drwtNo2;
		    	lottoNumber[2] = result.drwtNo3;
		    	lottoNumber[3] = result.drwtNo4;
		    	lottoNumber[4] = result.drwtNo5;
		    	lottoNumber[5] = result.drwtNo6;
		    	var bonus = result.bnusNo;
		    	$('#date').html('해당 회차 날짜 : ' + result.drwNoDate);
		        
		        // 2등은 5개 맞고 보너스 하나 맞고
		        for (var i = 0; i < 6; i++) {
		        	for (var j = 0; j < 6; j++) {
		        		if (inputNumber[i] == lottoNumber[j]) {
		        			correct++;
		        		}
		        	}
		        }
		        
		        var title = '당첨';
		       	var msg = '';
		        
		        if (correct == 6) { // 1등
					msg = '1등 당첨 축하드립니다.';
		        } else if (correct == 5) {
		        	for (var i = 0; i < 6; i++) {
		        		if (inputNumber[i] == bonus) { // 2등 : 5개 + 보너스
		        			msg = '2등 당첨 축하드립니다.';
							break;
		        		} else { // 3등 : 5개
		        			msg = '3등 당첨 축하드립니다.';
		        		}
		        	}
		        } else if (correct == 4) { // 4등 : 4개
		        	msg = '4등 당첨 축하드립니다.';
		        } else if (correct == 3) { // 5등 : 3개
		        	msg = '5등 당첨 축하드립니다.';
		        } else {
		        	title = '낙첨';
		        	msg = '다음 기회에...';
		        }
		        
		        $('#myModalLabel').html(title);
				$('.modal-body').html(msg);
		        $('#myModal').modal();
		    },
		    error: function (request,status, error) {
		        console.log(error);
		        alert(status);
		    }
		});
	});
});
</script>
</head>
<body>
<div id="wrap" class="container">
	<header id="header" class="jumbotron">
		<h1 class="display-5">Hello, Lotto World</h1>
		<p class="lead">This is Lotto Program</p>
		<hr class="my-4">
		<p id="info"> 참고사항 <br/>
		    1. 해당 회차를 입력하고 번호 가져올 수 있습니다.<br/>
		    2. 입력한 번호로 해당회차와 비교하여 1등 2등... 확인 가능 합니다. <br/><br/>
		</p>
	</header>
	<section id="content_section">
        <div id="lotto_head">
            <div class="form-group">
                <label for="lotto1">해당 회차 : </label>
                <div class="form-inline">
                    <input type="text" id="count" class="form-control">
                    <input type="button" id="getNumber" class="btn btn-primary" value="가져오기">
                </div>   
            </div>
            <div id="date">

            </div>  
        </div>
        <div id="lotto_body">
            <div class="form-group">
                <label for="number1">첫번째 번호 : </label>
                <input type="text" id="number1" class="form-control">
            </div>
            <div class="form-group">
                <label for="number2">두번째 번호 : </label>
                <input type="text" id="number2" class="form-control">
            </div>
            <div class="form-group">
                <label for="number3">세번째 번호 : </label>
                <input type="text" id="number3" class="form-control">
            </div>
            <div class="form-group">
                <label for="number4">네번째 번호 : </label>
                <input type="text" id="number4" class="form-control">
            </div>
            <div class="form-group">
                <label for="number5">다섯번째 번호 : </label>
                <input type="text" id="number5" class="form-control">
            </div>
            <div class="form-group">
                <label for="number6">여섯번째 번호 : </label>
                <input type="text" id="number6" class="form-control">
            </div>
            <div class="plus">
                +
            </div>
            <div class="form-group">
                <label for="bnusNo">보너스 번호 : </label>
                <input type="text" id="bnusNo" class="form-control">
            </div>
        </div>
        <div id="lotto_btns">
            <input type="button" id="resetAll" class="btn btn-primary" value="초기화">
            <input type="button" id="gogo" class="btn btn-primary" value="확인하기">
        </div>
    </section>
    <footer class="footer">
        <p>copyright&copy;2019.data world blog all right reserved.</p>
    </footer>

	<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	    	<h4 class="modal-title" id="myModalLabel"> </h4>
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	      </div>
	      <div class="modal-body">
	      	
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
	      </div>
	    </div>
	  </div>
	</div>
</div>
</body>
</html>