import 'package:flutter_riverpod/flutter_riverpod.dart';

class VehicleInfo {
  final String vin;
  final String make;
  final String model;
  final int year;
  final String engine;
  final String fuelType;

  VehicleInfo({
    required this.vin,
    required this.make,
    required this.model,
    required this.year,
    required this.engine,
    required this.fuelType,
  });
}

class VinService {
  // Simulation d'un décodage VIN
  Future<VehicleInfo> decodeVin(String vin) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulation réseau

    // Mock de données basées sur les 3 premiers caractères (WMI)
    if (vin.startsWith('WVW')) {
      return VehicleInfo(
        vin: vin,
        make: 'Volkswagen',
        model: 'Golf VII',
        year: 2015,
        engine: '2.0 TDI',
        fuelType: 'Diesel',
      );
    } else if (vin.startsWith('VF3')) {
      return VehicleInfo(
        vin: vin,
        make: 'Peugeot',
        model: '3008',
        year: 2018,
        engine: '1.2 PureTech',
        fuelType: 'Essence',
      );
    } else {
      return VehicleInfo(
        vin: vin,
        make: 'Générique',
        model: 'Modèle Inconnu',
        year: 2020,
        engine: '1.6 L',
        fuelType: 'Essence',
      );
    }
  }
}

final vinServiceProvider = Provider((ref) => VinService());

final vinDecoderProvider = FutureProvider.family<VehicleInfo, String>((
  ref,
  vin,
) {
  return ref.watch(vinServiceProvider).decodeVin(vin);
});
