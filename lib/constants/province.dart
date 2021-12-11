class Province {
  static final dynamic list = {
    "10": {
      "name": "Lào Cai",
      "code": 10
    },
    "11": {
      "name": "Điện Biên",
      "code": 11
    },
    "12": {
      "name": "Lai Châu",
      "code": 12
    },
    "14": {
      "name": "Sơn La",
      "code": 14
    },
    "15": {
      "name": "Yên Bái",
      "code": 15
    },
    "17": {
      "name": "Hoà Bình",
      "code": 17
    },
    "19": {
      "name": "Thái Nguyên",
      "code": 19
    },
    "20": {
      "name": "Lạng Sơn",
      "code": 20
    },
    "22": {
      "name": "Quảng Ninh",
      "code": 22
    },
    "24": {
      "name": "Bắc Giang",
      "code": 24
    },
    "25": {
      "name": "Phú Thọ",
      "code": 25
    },
    "26": {
      "name": "Vĩnh Phúc",
      "code": 26
    },
    "27": {
      "name": "Bắc Ninh",
      "code": 27
    },
    "30": {
      "name": "Hải Dương",
      "code": 30
    },
    "31": {
      "name": "Hải Phòng",
      "code": 31
    },
    "33": {
      "name": "Hưng Yên",
      "code": 33
    },
    "34": {
      "name": "Thái Bình",
      "code": 34
    },
    "35": {
      "name": "Hà Nam",
      "code": 35
    },
    "36": {
      "name": "Nam Định",
      "code": 36
    },
    "37": {
      "name": "Ninh Bình",
      "code": 37
    },
    "38": {
      "name": "Thanh Hóa",
      "code": 38
    },
    "40": {
      "name": "Nghệ An",
      "code": 40
    },
    "42": {
      "name": "Hà Tĩnh",
      "code": 42
    },
    "44": {
      "name": "Quảng Bình",
      "code": 44
    },
    "45": {
      "name": "Quảng Trị",
      "code": 45
    },
    "46": {
      "name": "Thừa Thiên Huế",
      "code": 46
    },
    "48": {
      "name": "Đà Nẵng",
      "code": 48
    },
    "49": {
      "name": "Quảng Nam",
      "code": 49
    },
    "51": {
      "name": "Quảng Ngãi",
      "code": 51
    },
    "52": {
      "name": "Bình Định",
      "code": 52
    },
    "54": {
      "name": "Phú Yên",
      "code": 54
    },
    "56": {
      "name": "Khánh Hòa",
      "code": 56
    },
    "58": {
      "name": "Ninh Thuận",
      "code": 58
    },
    "60": {
      "name": "Bình Thuận",
      "code": 60
    },
    "62": {
      "name": "Kon Tum",
      "code": 62
    },
    "64": {
      "name": "Gia Lai",
      "code": 64
    },
    "66": {
      "name": "Đắk Lắk",
      "code": 66
    },
    "67": {
      "name": "Đắk Nông",
      "code": 67
    },
    "68": {
      "name": "Lâm Đồng",
      "code": 68
    },
    "70": {
      "name": "Bình Phước",
      "code": 70
    },
    "72": {
      "name": "Tây Ninh",
      "code": 72
    },
    "74": {
      "name": "Bình Dương",
      "code": 74
    },
    "75": {
      "name": "Đồng Nai",
      "code": 75
    },
    "77": {
      "name": "Bà Rịa - Vũng Tàu",
      "code": 77
    },
    "79": {
      "name": "Hồ Chí Minh",
      "code": 79
    },
    "80": {
      "name": "Long An",
      "code": 80
    },
    "82": {
      "name": "Tiền Giang",
      "code": 82
    },
    "83": {
      "name": "Bến Tre",
      "code": 83
    },
    "84": {
      "name": "Trà Vinh",
      "code": 84
    },
    "86": {
      "name": "Vĩnh Long",
      "code": 86
    },
    "87": {
      "name": "Đồng Tháp",
      "code": 87
    },
    "89": {
      "name": "An Giang",
      "code": 89
    },
    "91": {
      "name": "Kiên Giang",
      "code": 91
    },
    "92": {
      "name": "Cần Thơ",
      "code": 92
    },
    "93": {
      "name": "Hậu Giang",
      "code": 93
    },
    "94": {
      "name": "Sóc Trăng",
      "code": 94
    },
    "95": {
      "name": "Bạc Liêu",
      "code": 95
    },
    "96": {
      "name": "Cà Mau",
      "code": 96
    },
    "01": {
      "name": "Hà Nội",
      "code": 1
    },
    "02": {
      "name": "Hà Giang",
      "code": 2
    },
    "04": {
      "name": "Cao Bằng",
      "code": 4
    },
    "06": {
      "name": "Bắc Kạn",
      "code": 6
    },
    "08": {
      "name": "Tuyên Quang",
      "code": 8
    }
  };
  static String getNameByCode(int code){
    if (code.toString().length == 1) {
      return list['0' + code.toString()]==null?"Chưa cập nhật":list['0' + code.toString()]['name'];
    }
    return list[code.toString()]==null?"Chưa cập nhật": list[code.toString()]['name'];
  }
  static int getCodeOfProvince(String name) {
    var fullProvinceList = [];
    list.values.forEach((val) => fullProvinceList.add(val));
    return fullProvinceList.firstWhere((element) => element[name]==name)['code'];
    // return int.parse(fullProvinceList
    //     .where((province) => province['name'] == name)
    //     .toList()[0]['code']);
  }
  static const _prioritizedProvinces = [
    "Đồng Nai",
    "Hà Nội",
    "Hồ Chí Minh",
  ];
  static List renderProvinceArray() {
    List initialProvinceList;
    initialProvinceList =
        list.entries.map((entry) => entry.value['name']).toList();
    initialProvinceList.sort();
    _prioritizedProvinces.forEach((element) {
      initialProvinceList.remove(element);
      initialProvinceList.insert(0, element);
    });

    return initialProvinceList;
  }
}