part of 'pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();

  Future<List<Province>?>? _provinces;
  Future<List<City>?>? _citiesOrigin;
  Future<List<City>?>? _citiesDestination;
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

  // Courier
  void _onCourierChanged(String courier) {
    _shippingCost.courier =
        Courier.values.firstWhere((value) => (value.value == courier));
  }

  String? _validateCourier(String? courier) {
    if (courier == null || courier.isEmpty) {
      return 'Kurir harus diisi';
    } else {
      return null;
    }
  }

  // Weight
  void _onWeightChanged(String? weight) {
    _shippingCost.weight = weight;
  }

  String? _validateWeight(String? weight) {
    if (weight == null || weight.isEmpty) {
      return 'Berat harus diisi';
    } else if (int.parse(weight) < 1) {
      return 'Berat harus lebih dari nol';
    } else {
      return null;
    }
  }

  // Province
  void _onProvinceOriginChanged(Province province) {
    _shippingCost.provinceOrigin = province;
    setState(() {
      // Reset cities
      _citiesOrigin = null;
      // Fetch cities
      _citiesOrigin = getCities(province.provinceId);
    });
  }

  void _onProvinceDestinationChanged(Province province) {
    _shippingCost.provinceDestination = province;
    setState(() {
      // Reset cities
      _citiesDestination = null;
      // Fetch cities
      _citiesDestination = getCities(province.provinceId);
    });
  }

  String? _validateProvince(Province? province) {
    if (province == null) {
      return 'Provinsi harus diisi';
    } else {
      return null;
    }
  }

  // City
  void _onCityOriginChanged(City city) {
    _shippingCost.cityOrigin = city;
  }

  void _onCityDestinationChanged(City city) {
    _shippingCost.cityDestination = city;
  }

  String? _validateCity(City? city) {
    if (city == null) {
      return 'Kota harus diisi';
    } else {
      return null;
    }
  }

  // Shipping cost
  void _onCheckShippingCost() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
                'Dari ${_shippingCost.cityOrigin!.cityName} ke ${_shippingCost.cityDestination!.cityName}'),
            action: SnackBarAction(
                textColor: Theme.of(context).colorScheme.inversePrimary,
                label: 'Dismiss',
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                }),
          ),
        );
    }
  }

  @override
  void initState() {
    super.initState();
    _provinces = getProvinces();
  }

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Raja Ongkir'),
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Space.medium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: TextFields.dropdown(
                            optionValues: Courier.values
                                .map((courier) => courier.value)
                                .toList(),
                            onChanged: (value) {
                              _onCourierChanged(value);
                            },
                            isExpanded: true,
                            labelText: 'Kurir',
                            validator: (value) {
                              return _validateCourier(value);
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                        ),
                        SizedSpacer.horizontal(),
                        Expanded(
                          child: TextFields.outlined(
                            controller: _weightController,
                            labelText: 'Berat',
                            suffixText: 'gr',
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              _onWeightChanged(value);
                            },
                            validator: (value) {
                              return _validateWeight(value);
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              FilteringTextInputFormatter.deny(
                                  Const.regexNonStartingZero),
                            ],
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                        ),
                      ],
                    ),
                    SizedSpacer.vertical(space: Space.medium),
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              'Daerah asal',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          SizedSpacer.vertical(),
                          FutureBuilder<List<Province>?>(
                            future: _provinces,
                            builder: ((context, snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.none:
                                  return TextFields.dropdown(
                                      optionValues: [],
                                      disabledHint: 'Provinsi');
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
                                        _onProvinceOriginChanged(value);
                                      },
                                      labelText: 'Provinsi',
                                      validator: (value) {
                                        return _validateProvince(value);
                                      },
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                    );
                                  } else {
                                    return const Text(
                                        'Tidak ada data provinsi');
                                  }
                              }
                            }),
                          ),
                          SizedSpacer.vertical(space: Space.medium),
                          if (_shippingCost.provinceOrigin != null)
                            FutureBuilder<List<City>?>(
                              future: _citiesOrigin,
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
                                          _onCityOriginChanged(value);
                                        },
                                        labelText: 'Kota',
                                        validator: (value) {
                                          return _validateCity(value);
                                        },
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                      );
                                    } else {
                                      return const Text('Tidak ada data kota');
                                    }
                                }
                              }),
                            )
                        ],
                      ),
                    ),
                    SizedSpacer.vertical(space: Space.medium),
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              'Daerah tujuan',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          SizedSpacer.vertical(),
                          FutureBuilder<List<Province>?>(
                            future: _provinces,
                            builder: ((context, snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.none:
                                  return TextFields.dropdown(
                                      optionValues: [],
                                      disabledHint: 'Provinsi');
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
                                        _onProvinceDestinationChanged(value);
                                      },
                                      labelText: 'Provinsi',
                                      validator: (value) {
                                        return _validateProvince(value);
                                      },
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                    );
                                  } else {
                                    return const Text(
                                        'Tidak ada data provinsi');
                                  }
                              }
                            }),
                          ),
                          SizedSpacer.vertical(space: Space.medium),
                          if (_shippingCost.provinceDestination != null)
                            FutureBuilder<List<City>?>(
                              future: _citiesDestination,
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
                                          _onCityDestinationChanged(value);
                                        },
                                        labelText: 'Kota',
                                        validator: (value) {
                                          return _validateCity(value);
                                        },
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                      );
                                    } else {
                                      return const Text('Tidak ada data kota');
                                    }
                                }
                              }),
                            ),
                        ],
                      ),
                    ),
                    SizedSpacer.vertical(space: Space.large),
                    FilledButton(
                      onPressed: _onCheckShippingCost,
                      label: 'Cek ongkir',
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
