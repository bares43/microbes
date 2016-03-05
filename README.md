# Microbes simulator

## Usage
### 1. Run pub
```
pub get
```
### 2. Create microbes
* In src/app/MicrobesGenerator.dart create instances of microbes and their DNA.
* After creating microbes call game.addMicrobes()
* By using DNA you can influence behavior of microbe.
* Whenever the microbes multiply his DNA is cloned.
* Using mutation function on DNA class you can describe mutation of DNA. For example:
```
dna.mutation = (DNA dna, DNA root){
    // every new generation increment value but every 10th generation reset back to root DNA value
    if(dna.generation % 10 == 0){
        dna.multiply_period = root.multiply_period;
    }else{
        dna.multiply_period++;
    }
}
```

### 3. Translate Dart into JS
```
mkdir build
dart2js --out=build/app.js src/app/App.dart
```

### 4. Run index.html, click to "start" and have fun :)