## Random Joke App Uygulama Kullanımı
| Tek Şaka | Birden Fazla Şaka İsteği |
|---------|---------|
| <img src="https://github.com/user-attachments/assets/1c9e0254-91f7-468d-87ee-33cfc7482cdf" alt="Video 1" width="300"/> | <img src="https://github.com/user-attachments/assets/497ceaac-9f46-48a5-8e5c-bf05148499f5" alt="Video 2" width="300"/> |


 <details>
    <summary><h2>Uygulamanın Amacı</h2></summary>
    Proje Amacı
   Bu uygulama, kullanıcıların rastgele şakalar görüntülemesini sağlayan basit bir kullanıcı arayüzü sunar. Kullanıcı, "New Joke" butonuna tıkladığında yeni bir şaka alır. Uygulamanın temel amacı, kullanıcıların günlük yaşamlarına biraz neşe katmak ve rastgele şaka paylaşımı ile eğlenceli bir deneyim sunmaktır.
  </details>  

  <details>
    <summary><h2>MVVM Yapısı</h2></summary>
    Bu proje, MVVM (Model-View-ViewModel) mimarisi kullanılarak tasarlanmıştır.
    Model: Joke yapısı, şakanın içeriğini temsil eder ve ağdan gelen verileri işler. Ayrıca, Webservice sınıfı, veri çekme işlevselliğini yönetir.
    View: MainView, kullanıcı arayüzünü temsil eder. Kullanıcı, bu arayüz üzerinden şakaları görüntüler ve yeni şakalar alır.
    ViewModel: JokeListViewModel, model ile görünüm arasında bir köprü görevi görür. Veriyi işler ve günceller; bu sayede UI katmanı, model katmanındaki değişikliklerden haberdar olur ve otomatik olarak güncellenir.
     Bu yapı, uygulamanın daha iyi bir şekilde yönetilmesini ve genişletilmesini sağlar. Kullanıcı arayüzü ve iş mantığı arasında net bir ayrım oluşturarak, kodun okunabilirliğini ve sürdürülebilirliğini artırır.
  </details> 

  <details>
    <summary><h2>Joke Model</h2></summary>
    struct Joke: Şaka verilerini temsil eden model yapısıdır. Codable protokolünü benimseyerek JSON verilerini kolayca çözebilir. type, setup, punchline, ve id gibi alanlara sahiptir.

    
    ```
      struct Joke : Codable {
    let type: String
    let setup: String
    let punchline: String
    let id : Int
    }


    ```
  </details> 

  <details>
    <summary><h2>Webservice</h2></summary>
    class Webservice: Uygulamanın şaka verilerini indirmek için kullanılan servis katmanıdır. downloadJoke(url: URL) metodu, belirtilen URL'den şaka verilerini çeker ve bunları Joke modeline dönüştürmek için JSONDecoder kullanır. Bu yapı, ağ isteklerini yöneterek uygulamanın veri akışını düzenler
    
    ```
        class Webservice {
    
    
    func downloadJoke(url: URL) async throws -> Joke {
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do{
            let joke = try JSONDecoder().decode(Joke.self, from: data)
            return joke
        } catch {
            print("Error decoding Joke: \(error)")
            throw error
        }
    }
    
    
    
    }



    
    ```
  </details> 


  <details>
    <summary><h2>JokeViewModel</h2></summary>
    struct JokeViewModel: Bir Joke nesnesini temsil eden bir sarmalayıcıdır. Bu yapı, Joke nesnesinin belirli alanlarını (id, setup, punchline, type) kolayca erişilebilir hale getirir. Bu, UI katmanı için daha temiz bir veri yönetimi sağlar.
    
    ```

    struct JokeViewModel {
    let joke: Joke
    
    var id: Int {
        joke.id
    }
    
    var punchline: String {
        joke.punchline
    }
    
    var setup: String {
        joke.setup
    }
    
    var type: String {
        joke.type
    }
    }


    ```
  </details> 

  <details>
    <summary><h2>JokeListViewModel</h2></summary>
    @Published var jokeList: Şaka verilerini depolamak için kullanılan bir dizidir. @Published özelliği sayesinde, bu liste güncellendiğinde kullanıcı arayüzü otomatik olarak güncellenir.
    downloadJokesAsync(url: URL): Asenkron bir fonksiyon olup, belirtilen URL'den şaka indirir. İndirdiği şakayı JokeViewModel ile sarmalayarak jokeList dizisine ekler. Bu yapı, uygulamanın asenkron işlemlerini yönetir ve kullanıcı deneyimini iyileştirir.
    
    ```
            @MainActor
    class JokeListViewModel : ObservableObject {
    
    @Published var jokeList = [JokeViewModel]()
    let webservice = Webservice()
   
    
    func downloadJokesAsync(url: URL) async {
        do {
            let Joke = try await webservice.downloadJoke(url: url)
            self.jokeList.append(JokeViewModel(joke: Joke))
            
        } catch {
            
        }
    }
    
    }


    ```
  </details> 

  <details>
    <summary><h2>MainView</h2></summary>
    @ObservedObject var jokeListViewModel: JokeListViewModel: Uygulama, JokeListViewModel sınıfını gözlemleyerek şaka listesini günceller. Bu yapı, MVVM (Model-View-ViewModel) mimarisinin bir parçasıdır.
    @State private var sakla: Kullanıcının yeni bir şaka alırken mevcut şakaları temizleyip temizlemeyeceğini kontrol eden bir değişkendir. Bu değişkenin değeri değiştiğinde, arayüz otomatik olarak güncellenir.
    body: Uygulamanın ana görsel bileşenini tanımlar. Kullanıcı arayüzü, bir NavigationStack, ScrollView ve bir dizi buton içerir. Şaka listesi burada görüntülenir.
    Button: "New Joke" butonuna tıklandığında, jokeListViewModel aracılığıyla yeni bir şaka indirilir. sakla değişkenine bağlı olarak mevcut şakaların durumu yönetilir.
    
    ```
       struct MainView: View {
    
    @ObservedObject var jokeListViewModel: JokeListViewModel
    @State private var sakla = true
    
    init() {
        self.jokeListViewModel = JokeListViewModel()
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(jokeListViewModel.jokeList, id: \.id) { joke in
                            VStack {
                                Text(joke.type)
                                    .font(.headline)
                                    .padding()
                                Text(joke.setup)
                                    .padding()
                                Text(joke.punchline)
                                    .padding()
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .padding()
                        }
                    }
                    .padding()
                }
                Button {
                    Task {
                        if sakla {
                    jokeListViewModel.jokeList.removeAll(keepingCapacity: true)
                        }
                    await jokeListViewModel.downloadJokesAsync(url: URL(string: "https://official-joke-api.appspot.com/random_joke")!)
                    }
                } label: {
                    Text("New Joke")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }.toolbar(content: {
                Button {
                    self.sakla.toggle()
                } label: {
                    Text(sakla ? "Hide" : "Show")
                }

            })
            .navigationTitle("Random Joke App")
        }
        .task {
            await jokeListViewModel.downloadJokesAsync(url: URL(string: "https://official-joke-api.appspot.com/random_joke")!)
        }
    }
    }



    ```
  </details> 

<details>
    <summary><h2>Uygulama Görselleri</h2></summary>
    <table style="width: 100%;">
        <tr>
            <td style="text-align: center; width: 50%;">
                <h4 style="font-size: 14px;">Kullanıcının İsteğine Göre Tek Şaka</h4>
                <img src="https://github.com/user-attachments/assets/d5796e64-d650-4471-b8b5-710112a6017f" style="max-width: 300px; height: auto;">
            </td>
            <td style="text-align: center; width: 50%;">
                <h4 style="font-size: 14px;">Kullanıcının İsteğine Göre Çoklu Şaka</h4>
                <img src="https://github.com/user-attachments/assets/eff20e48-5798-41dd-b3e0-00af86fbd7ec" style="max-width: 300px; height: auto;">
            </td>
        </tr>
    </table>
</details>


