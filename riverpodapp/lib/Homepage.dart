import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum City{
  Delhi,
  paris,
  tokyo,
}
typedef WeatherPic= String;

 Future<WeatherPic> getWeather(City city){
  return Future.delayed(
    const Duration(seconds: 1), () =>  {
    City.Delhi: '🌞',
    City.paris: '⛈️',
    City.tokyo: '❄️',

  }[city] ?? 'Hum pe haihiNO! 😝',
  );

 }

 //UI writes to  and read from this 
 final currentCityProvider = StateProvider<City?>((ref) => null,);

 const unknownSign = '🤷🏻';

 // UI Read this
 final weatherProvider = FutureProvider<WeatherPic>((ref) {
  final city = ref.watch(currentCityProvider);        // to listen the changes occur in currentcityProvider

  if(city != null){
    return getWeather(city);
  }
  else{
    return unknownSign;
  }

   
 },);

class HomePage extends ConsumerWidget {
  const HomePage({Key ? key}): super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWeather = ref.watch(weatherProvider);

    // currentWeather.when(

    // )              // when is used here to provide data or widgets for various states of thsi async value
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather'),
      ),

      body: Column(
        children: [
          currentWeather.when(
            data: (data)=> Text(data, style: TextStyle(fontSize: 40),),
             error: (_ , __) => Text('Error'), loading: () => Padding(
               padding: const EdgeInsets.all(8.0),
               child: CircularProgressIndicator(),
             ) ),
          Expanded(
            child: ListView.builder(
              itemCount: City.values.length,
              itemBuilder: (context, index){
                final city = City.values[index];
               final isSelected = city == ref.watch(currentCityProvider);  // so any change in this will build entire widget

               return ListTile(
                title: Text(city.toString(),

                ),
                trailing: isSelected ? const Icon(Icons.check) : null,
                onTap: () {
                  ref.read(currentCityProvider.notifier).state = city;
                },
               );
              }
              ),
              ),

        ],
      )

    );
  }
}