part of 'pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();

  Future<List<Province>?>? _provinces;
  Future<List<City>?>? _cities;
  final ShippingCost _shippingCost = ShippingCost();

  Future<List<Province>?> getProvinces() async {
    List<Province>? provinces;
    await MasterDataService.getProvinces().then((value) {
      setState(() {
        provinces = value;
      });
    });
    return provinces;
  }

  Future<List<City>?> getCities(dynamic provinceId) async {
    List<City>? cities;
    await MasterDataService.getCities(provinceId).then((value) {
      setState(() {
        cities = value;
      });
    });
    return cities;
  }

  void _onCourierChanged(String courier) {
    _shippingCost.courier = Courier.values.byName(courier);
  }

  String? _validateCourier(String? courier) {
    if (courier == null || courier.isEmpty) {
      return 'Kurir tidak boleh kosong';
    } else {
      return null;
    }
  }

  void _onProvinceChanged(Province province) {
    _shippingCost.province = province;
    // Reset city
    setState(() {
      _cities = null;
    });
    // Fetch cities
    _cities = getCities(province.provinceId);
  }

  String? _validateProvince(String? province) {
    if (province == null || province.isEmpty) {
      return 'Provinsi tidak boleh kosong';
    } else {
      return null;
    }
  }

  void _onCityChanged(City city) {
    _shippingCost.city = city;
  }

  String? _validateCity(String? city) {
    if (city == null || city.isEmpty) {
      return 'Kota tidak boleh kosong';
    } else {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _provinces = getProvinces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Raja Ongkir'),
      ),
      body: SafeArea(
        bottom: false,
        minimum: const EdgeInsets.all(Space.medium),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFields.dropdown(
                      optionValues: Courier.values
                          .map((courier) => courier.value.toString())
                          .toList(),
                      onChanged: (value) {
                        _onCourierChanged(value);
                      },
                      labelText: 'Kurir',
                      validator: (value) {
                        return _validateCourier(value);
                      },
                    ),
                    SizedSpacer.vertical(space: Space.large),
                    FutureBuilder<List<Province>?>(
                      future: _provinces,
                      builder: ((context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                            return TextFields.dropdown(
                                optionValues: [], disabledHint: 'Provinsi');
                          case ConnectionState.waiting:
                            return const CircularProgressIndicator();
                          default:
                            if (snapshot.hasData) {
                              return TextFields.dropdown(
                                optionValues: snapshot.data!
                                    .map((value) => value.province!)
                                    .toList(),
                                options: snapshot.data,
                                onChanged: (value) {
                                  _onProvinceChanged(value);
                                },
                                labelText: 'Provinsi',
                                validator: (value) {
                                  return _validateProvince(value);
                                },
                              );
                            } else {
                              return const Text('Tidak ada data provinsi');
                            }
                        }
                      }),
                    ),
                    SizedSpacer.vertical(space: Space.large),
                    if (_shippingCost.province != null)
                      FutureBuilder<List<City>?>(
                        future: _cities,
                        builder: ((context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                              return TextFields.dropdown(
                                  optionValues: [],
                                  disabledHint:
                                      'Provinsi harus diisi terlebih dahulu');
                            case ConnectionState.waiting:
                              return const CircularProgressIndicator();
                            default:
                              if (snapshot.hasData) {
                                return TextFields.dropdown(
                                  optionValues: snapshot.data!
                                      .map((value) => value.cityName!)
                                      .toList(),
                                  options: snapshot.data,
                                  onChanged: (value) {
                                    _onCityChanged(value);
                                  },
                                  labelText: 'Kota',
                                  validator: (value) {
                                    return _validateCity(value);
                                  },
                                );
                              } else {
                                return const Text('Tidak ada data kota');
                              }
                          }
                        }),
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
