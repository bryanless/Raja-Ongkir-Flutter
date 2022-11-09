part of 'pages.dart';

class Ongkirpage extends StatefulWidget {
  const Ongkirpage({Key? key}) : super(key: key);

  @override
  State<Ongkirpage> createState() => _OngkirpageState();
}

class _OngkirpageState extends State<Ongkirpage> {
  bool isLoading = false;
  String dropdownvalue = 'jne';
  var kurir = ['jne', 'pos', 'tiki'];

  final _beratController = TextEditingController();

  dynamic provId;
  dynamic provinceData;
  dynamic selectedProv;
  Future<List<Province>> getProvinces() async {
    dynamic listProvince;
    await MasterDataService.getProvinces().then((value) {
      setState(() {
        listProvince = value;
      });
    });
    return listProvince;
  }

  dynamic cityId;
  dynamic cityData;
  dynamic selectedCity;
  Future<List<City>> getCities(dynamic provId) async {
    dynamic listCity;
    await MasterDataService.getCities(provId).then((value) {
      setState(() {
        listCity = value;
      });
    });
    return listCity;
  }

  @override
  void initState() {
    super.initState();
    provinceData = getProvinces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hitung Ongkir"),
      ),
      body: Stack(
        children: [
          SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: [
                  //Flexible untuk form
                  Flexible(
                    flex: 2,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              DropdownButton(
                                  value: dropdownvalue,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  items: kurir.map((String items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(items),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownvalue = newValue!;
                                    });
                                  }),
                              SizedBox(
                                  width: 200,
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: _beratController,
                                    decoration: InputDecoration(
                                      labelText: 'Berat (gr)',
                                    ),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      return value == null || value == 0
                                          ? 'Berat harus diisi atau tidak boleh 0!'
                                          : null;
                                    },
                                  ))
                            ],
                          ),
                        ),
                        const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Origin",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            )),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 210,
                                  child: FutureBuilder<List<Province>>(
                                      future: provinceData,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return DropdownButton(
                                              isExpanded: true,
                                              value: selectedProv,
                                              icon: Icon(Icons.arrow_drop_down),
                                              iconSize: 30,
                                              elevation: 16,
                                              style: TextStyle(
                                                  color: Colors.black),
                                              hint: selectedProv == null
                                                  ? Text('Pilih provinsi')
                                                  : Text(selectedProv.province),
                                              items: snapshot.data!.map<
                                                      DropdownMenuItem<
                                                          Province>>(
                                                  (Province value) {
                                                return DropdownMenuItem(
                                                    value: value,
                                                    child: Text(value.province
                                                        .toString()));
                                              }).toList(),
                                              onChanged: (newValue) {
                                                setState(() {
                                                  selectedProv = newValue;
                                                  provId =
                                                      selectedProv.provinceId;
                                                });
                                                selectedCity = null;
                                                cityData = getCities(provId);
                                              });
                                        } else if (snapshot.hasError) {
                                          debugPrint(snapshot.error.toString());
                                          return Text("Tidak ada data.");
                                        }
                                        return const CircularProgressIndicator();
                                      }),
                                )
                              ],
                            )),
                      ],
                    ),
                  ),

                  //Felxible untuk nampilin data
                  Flexible(
                    flex: 2,
                    child: Container(),
                  )
                ],
              )),
          isLoading == true ? const CircularProgressIndicator() : Container(),
        ],
      ),
    );
  }
}
