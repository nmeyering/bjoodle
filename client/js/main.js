bjoodleApp = angular.module('bjoodleApp',[]);

/* Komischer Hack
bjoodleApp.config(['$httpProvider', function($httpProvider) {
	$httpProvider.defaults.useXDomain = true;
	delete $httpProvider.defaults.headers.common['X-Requested-With'];
}]);
*/

bjoodleApp.factory('bjBoyFactory',['$http',function($http) {
		var useDomain = document.domain != '' ? document.domain : "localhost";
		var urlBase = 'http://' + useDomain + ':8002/api';

		var bjBoyFactory = {};

		bjBoyFactory.getBjBoyz = function() {
			return $http.get(urlBase);
		};

		bjBoyFactory.putBjBoy = function(boy) {
			return $http.post(urlBase,boy);
		};

		bjBoyFactory.removeBjBoy = function(boyName) {
			return $http.delete(urlBase+'?name='+boyName);
		};

		return bjBoyFactory;
}]);

bjoodleApp.controller('MainController',function($scope,bjBoyFactory) {
		//$scope.bjBoyz = { "nille" : ['14:00','14:00','14:00','14:00','14:00','14:00','14:00'] };
		$scope.bjBoyz = {};
		$scope.status = '';
		$scope.liste = '';

		$scope.initNewBjBoy = function() {
			$scope.newBoyName = '';
			$scope.newBoyTimes = jQuery.map(
				['20:00','20:00','20:00','20:00','20:00','20:00','20:00'],
				function(element,index) {
					return { 'value' : element };
				});
		};

		$scope.getBjBoyz = function(){
			bjBoyFactory.getBjBoyz()
				.success(function (boyz) {
					$scope.bjBoyz = jQuery.map(boyz,function(value,name) {
						return { 'name' : name,'times' : value };
					});

					$scope.calcAvailable();
			    	})
			    	.error(function (error) {
					$scope.status = 'Unable to give blowjobs: ' + error.message;
			    	});
		};

		$scope.putNewBjBoy = function() {
			$scope.putBjBoy({ "name" : $scope.newBoyName,"times" : jQuery.map($scope.newBoyTimes,function(element,index) { return element.value; }) });
		}

		$scope.removeBjBoy = function(name) {
			bjBoyFactory.removeBjBoy(name)
				.success(function (boyz) {
					$scope.getBjBoyz();
					$scope.calcAvailable();
					$scope.status = 'removed'
			    	})
			    	.error(function (error) {
					$scope.status = 'Unable to give blowjobs: ' + error.message;
			    	});
		}

		$scope.putBjBoySeparate = function(name,times) {
			$scope.putBjBoy({ "name" : name,"times" : times });
		};

		$scope.putBjBoy = function (bjBoy) {
			bjBoyFactory.putBjBoy(bjBoy)
				.success(function () {
					$scope.status = 'bj';
					$scope.getBjBoyz();
					$scope.initNewBjBoy();
				})
				.error(function (error) {
					$scope.status = 'Unable to give bj: ' + error.message;
				});
		};	

		$scope.calcAvailable = function() {
			$scope.liste = jQuery.map(
				jQuery.grep(
					jQuery.map(
						$scope.bjBoyz,
						function(boy) {
							return { 'name' : boy.name, 'time' : boy.times[(new Date().getDay()+6) % 7] };
						}
					),
					function(a) {
						return a.time && a.time.length != '';
					}),
				function(a) {
					return a.name;
				}
			);
		};

		$scope.initNewBjBoy();
		$scope.getBjBoyz();
});
