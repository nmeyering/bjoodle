bjoodleApp = angular.module('bjoodleApp',[]);


bjoodleApp.factory('bjBoyFactory',['$http',function($http) {
		var urlBase = 'http://localhost:8000/api';	

		var bjBoyFactory = {};

		bjBoyFactory.getBjBoyz = function() {
			return $http.get(urlBase);
		};

		bjBoyFactory.putBjBoy = function(boy) {
			return $http.post(urlBase,boy);
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
			$scope.newBoyTimes = ['20:00','20:00','20:00','20:00','20:00','20:00','20:00'];
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
			$scope.putBjBoy({ "name" : $scope.newBoyName,"times" : $scope.newBoyTimes });
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
