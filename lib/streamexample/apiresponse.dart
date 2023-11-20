
enum Status { loading, completed, error }
class ApiResponse<T>{
  Status? status;
  T? data;
  String? message;
  //named constructor
  ApiResponse.loadingState(this.message) {
    status = Status.loading;
  }

  ApiResponse.completedState(this.data) {
    status = Status.completed;
  }

  ApiResponse.errorState(this.message) {
    status = Status.error;
  }
}