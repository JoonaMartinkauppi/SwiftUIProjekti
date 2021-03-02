
import SwiftUI
// Yksinkertainen appi teksti-TV:n selaamiseen YLE:n rajapinnan kautta



// Alla tuskin fiksuin tapa hoitaa Kuvan hakua internetistä, mutta en saanut frameworkkeja "URLImage" tai "KingFisher" toimimaan, vaikka
// itse asennuksessa ei ollut ongelmia. En osaa sanoa johtuiko virtuaalikoneen käytöstä vai jostain muusta.
extension String{
    // Lisätään Stringiin funktio load(), joka voidaan sitten koodissa lyödä stringimuotoisen urlin perään
    // Funktio palauttaa UIImagen, jossa on URLista löytyvä kuva taikka oletuskuva "Not Found" mikäli url on virheellinen.
    func load() -> UIImage{
        do {
            guard let url = URL(string:self) else{
                return UIImage()
                //guard let siltä varalta että string ei muunnu urliksi
                //Funktio pystyy palauttamaan silti UIImagen, koska UIImage ei ole kuva, vaan kuvan datan sisältävä objekti.
                //Tässä tapauksessa siis funktio palauttaisi UIImagen missä ei ole dataa sisällä.
            }
            let data: Data = try Data(contentsOf: url)
            return UIImage(data:data)
                // Mikäli annetusta urlista löytyy image-dataa, säilötään se palautettavaan UIImageen
            ?? UIImage()
        } catch  {
            print("Virhe")
        }
        return UIImage(named: "NotFound")!
        //Oletuksena palautetaan kuva "NotFound"
    }
}

struct omaButtonStyle : ButtonStyle {
    // Koodin selkeyttämiseksi buttonien tyyli on määritelty omaButtonStyle - struct, joka noudattaa ButtonStyle-protokollaa
    // toteuttaen funktion func makeBody(configuration: Self.Configuration) -> some View. Lisätään tyyliin buttoneiden koot ja värit.
    // developer.apple.com/documentation/swiftui/buttonstyle
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(30)
    }
}

struct ContentView: View {
    // Määritellään alussa muuttujat teksti-TV:n sivuja varten, sekä kuvan koon skaalaukseen.
    // YLE:n tarjoama API-avain on henkilökohtainen, mutta se on vapaasti saatavilla kenelle tahansa yle-tunnuksilla
    // osoitteesta tunnus.yle.fi/api-avaimet
    @State var nro = 100
    @State var nro2 = 1
    @State var sivuNro = "100"
    @State var alaNro = "1"
    @State var kayttajaNro = ""
    @State var Scale : CGFloat = 1.0
    let urlAlku:String = "https://external.api.yle.fi/v1/teletext/images/"
    let apiKey:String = "xxx"
    
    
    var body: some View {
        // Laitetaan ensin sovellukselle taustaväri, eli Z-stackin alimmainen taso värjätään allaolevalla värillä
        ZStack{
            Color(red:1 , green: 228/255, blue: 228/255)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            VStack{
                // Taustavärin päälle lisätään V-, ja Hstackit
                // VStackiin tulee infoboksi kertomaan nykyisen sivunumeron ja alanumeron, sekä mahdollisuus kirjoittaa haluttu sivunumero suoraan
                let _:String = urlAlku + sivuNro + "/" + alaNro + ".png?" + apiKey
                Spacer()
                Spacer()
                VStack {
                    Text("Sivu: " + sivuNro + " Alasivu: " + alaNro)
                        .font(.headline)
                    TextField("Siirry sivulle:", text: $kayttajaNro)
                        .padding(.bottom)
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .font(.headline)
                }
                HStack {
                    //Hstackiin lisätään buttonit, joilla voidaan selata sivuja edestakaisin
                    Button(action: {
                        self.nro -= 1
                        self.sivuNro = String(self.nro)
                        self.nro2 = 1
                        self.alaNro = String(nro2)
                    }, label: {
                        Text("Taakse")
                    }).padding(.leading, 10.0).buttonStyle(omaButtonStyle())
                    
                    Spacer()
                    
                    Button(action: {
                        self.nro2 -= 1
                        self.alaNro = String(self.nro2)
                    }, label: {
                        Text("<")
                    }).buttonStyle(omaButtonStyle())
                    
                    Spacer()
                    
                    Button(action: {
                        self.nro = Int(self.kayttajaNro) ?? 100
                        //virheentarkistus mikäli käyttäjä ei anna kokonaislukua
                        self.sivuNro = self.kayttajaNro
                        self.kayttajaNro = ""
                    }, label: {
                        Text("OK")
                    }).buttonStyle(omaButtonStyle())
                    
                    Spacer()
                    
                    Button(action: {
                        self.nro2 += 1
                        self.alaNro = String(self.nro2)
                    }, label: {
                        Text(">")
                    }).buttonStyle(omaButtonStyle())
                    
                    Spacer()
                    
                    Button(action: {
                        self.nro += 1
                        self.sivuNro = String(self.nro)
                        self.nro2 = 1
                        self.alaNro = String(nro2)
                    }, label: {
                        Text("Eteen")
                    }).buttonStyle(omaButtonStyle())
                    .padding(.trailing, 10.0)
                }
                .padding(.bottom, 5.0)
            }
            let testiUrl2:String = urlAlku + sivuNro + "/" + alaNro + ".png?" + apiKey
            VStack(){
                // Z-stackin ylimmälle tasolle laitetaan tekstiTV-kuva, joka haetaan ylen rajapinnasta
                // Linkki APIin muodostetaan yllä, ja käytetään Stringiin alussa lisättyä load()-funktiota kuvan hakemiseen.
                // Lisätään vielä käyttäjälle mahdollisuus muuttaa kuvan skaalausta, jotta teksti-TV:tä on helpompi lukea vaakatasossa.
                Image(uiImage: testiUrl2.load())
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(Scale, anchor: .top)
                    .gesture(TapGesture().onEnded{
                        if(Scale == 0.6){
                            Scale = 1.0
                        }
                        else{
                            Scale = 0.6
                        }
                    })
                Spacer()
            }
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
