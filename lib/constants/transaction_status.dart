enum TransactionStatus{
  initialized, //100
  announced, // 101
  successful, // 200
  cancel, // 400
  timeout, // 401
  wrong, // 402
  refuse, // 403
  error, // 500
}

/*
  Mã:
  100: Giao dịch được khởi tạo
  101: Người dùng đã chuyển tiền và thông báo đến admin
  200: Giao dịch thành công
  400: Người dùng huỷ giao dịch
  401: Hết thời gian giao dịch
  402: Số tiền chuyển không khớp
  403: Giao dịch thất bại, không nhận được tiền đã xác minh
  500: Người dùng đã chuyển nhưng hệ thống không nhận được

  Các mã breakpoint [Không thể chỉnh sửa khi đã đặt]
  200, 400, 402, 403
 */

class TransactionUtils {
  static int toCode(TransactionStatus transactionStatus){
    switch (transactionStatus){
      case TransactionStatus.initialized: return 100;
      case TransactionStatus.announced: return 101;
      case TransactionStatus.successful: return 200;
      case TransactionStatus.cancel: return 400;
      case TransactionStatus.timeout: return 401;
      case TransactionStatus.wrong: return 402;
      case TransactionStatus.refuse: return 403;
      case TransactionStatus.error: return 500;
    }
  }
  static TransactionStatus toEnum(int code){
    switch (code){
      case 100: return TransactionStatus.initialized;
      case 101: return TransactionStatus.announced;
      case 200: return TransactionStatus.successful;
      case 400: return TransactionStatus.cancel;
      case 401: return TransactionStatus.timeout;
      case 402: return TransactionStatus.wrong;
      case 403: return TransactionStatus.refuse;
      case 500: return TransactionStatus.error;
      default: return TransactionStatus.initialized;
    }
  }
  static bool isBreakPoint({int? code,TransactionStatus? transactionStatus }){
    if(code != null){
      if(code==200||code==400||code==402||code==403) return true;
    }
    if(transactionStatus != null){
      if(transactionStatus== TransactionStatus.successful || transactionStatus== TransactionStatus.cancel || transactionStatus== TransactionStatus.wrong || transactionStatus == TransactionStatus.refuse) return true;
    }
    return false;
  }
}
