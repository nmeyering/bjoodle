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
		$scope.newBoyName = '';
		$scope.newBoyTimes = ['20:00','20:00','20:00','20:00','20:00','20:00','20:00'];

		$scope.getBjBoyz = function(){
			bjBoyFactory.getBjBoyz()
				.success(function (boyz) {
					$scope.bjBoyz = jQuery.map(boyz,function(value,name) {
						return { 'name' : name,'times' : value };
					});
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
		}

		$scope.putBjBoy = function (bjBoy) {
			bjBoyFactory.putBjBoy(bjBoy)
				.success(function () {
					$scope.status = 'bj';
					$scope.getBjBoyz();
				})
				.error(function (error) {
					$scope.status = 'Unable to give bj: ' + error.message;
				});
		};	

		$scope.getBjBoyz();
});
