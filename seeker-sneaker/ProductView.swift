//
//  ProductView.swift
//  seeker-sneaker
//
//  Created by Dominic Gutierrez on 3/18/21.
//

import SwiftUI
import SwiftUICharts
import Firebase

struct ProductView: View {
    
    @State var data: [Double] = []
        
    @State var text = ""
    @State var highestbid = ""
    @State var lowestask = ""
    @State var pricehistory = ""
    @State var update_page = 0
    
    @State var bid = ""
    @State var ask = ""

    @State var highestbids: [String] = []
    @State var lowestasks: [String] = []
    @State var pricehistories: [String] = []

    
    @State var expand = false
    @State private var selected_size = 7.5
    var product: Feed = feedData[0]
    
    
    
    var body: some View {
        VStack{
            ScrollView{
                VStack {
                    Text(product.title.capitalized)
                        .font(.largeTitle)
                        .padding(.vertical, 20)
                        .multilineTextAlignment(.center)
                    HStack{
                        if !expand {
                            Text("Size:")
                                
                        }
                        Button(action: {
                            self.expand.toggle()
                        }) {
                            if expand {
                                Text("Select")
                            }
                            else if selected_size == floor(selected_size) {
                                Text(String(format: "%.0f", selected_size))
                            } else {
                                Text(String(format: "%.1f", selected_size))
                            }
                        }
                    }
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding()
                        .frame(width: 112, height: 30)
                        .background(Color.white)
                        .cornerRadius(35.0)
                        .overlay (RoundedRectangle(cornerRadius: 35) .stroke())
                    if expand {
                    Picker("Size", selection: $selected_size){
                        // should iterate through sizes from db
                        Text("7.5").tag(7.5)
                        Text("8").tag(8.0)
                        Text("8.5").tag(8.5)
                        Text("9").tag(9.0)
                        Text("9.5").tag(9.5)
                        Text("10").tag(10.0)
                        Text("10.5").tag(10.5)
                        Text("11").tag(11.0)
                        Text("11.5").tag(11.5)
                        Text("12").tag(12.0)
                    }
                    .pickerStyle(WheelPickerStyle())
                    .padding(.vertical, -10)
                    }
                    
                    HStack(spacing: 50){
                        NavigationLink(destination: BuyView(size: selected_size, product: product)){
                            VStack{
                                Text("Lowest Ask")
                                // Price for size from db
                                Text("$" + ask)
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 150, height: 60)
                            .background(Color.green)
                            .cornerRadius(35.0)
                        }
                        
                        NavigationLink(destination: SellView(size: selected_size, product: product)){
                            VStack{
                                Text("Highest Offer")
                                // Price for size from db
                                Text("$" + bid)
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 150, height: 60)
                            .background(Color.red)
                            .cornerRadius(35.0)

                        }
                    }.onAppear(perform: {
                        
                        if (update_page == 0){
                            download()
                        }
                        
                    })
                    
                    .padding(.vertical, 20)
                    
                    Image(product.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                    // Visualization of Past Sales
                    Spacer()
                    

                    LineView(data: data,
                             title: "Price History",
                             legend: "All Sales",
                             valueSpecifier: "$%.0f")
                        .frame(height: UIScreen.main.bounds.size.height)
                        .padding()

                }
                .padding(.vertical, -45)

            }
        }

    }

    func download() {
        
        // look into "transactions" collections for names that match with the product
        // if so update the values for the lowest
        
        let db = Firestore.firestore()
        db.collection("transactions").addSnapshotListener {(snap, err) in


            if err != nil {
                print("There is an error downloading content from the database.")
                return
            }
            
            // stores the append values of pricehistory from the DB
            var storage: [Double] = []

            for i in snap!.documentChanges {
                let documentId = i.document.documentID
                let highestbid = i.document.get("highestbid")
                let lowestask = i.document.get("lowestask")
                let pricehistory = i.document.get("pricehistory")
                
                ask = ("\(lowestask!)")
                bid = ("\(highestbid!)")

                
                // removes extraneous characters and stores or appends purely purchase prices
                let prices = ("\(pricehistory!)")
                let stringArray = prices.components(separatedBy: CharacterSet.decimalDigits.inverted)
                for item in stringArray {
                    if let history = Int(item) {
                        print("number: \(history)")
                        storage.append(Double(history))
                    }
                }
                
                DispatchQueue.main.async {
                    highestbids.append("\(highestbid!)")
                    lowestasks.append("\(lowestask!)")
                    pricehistories.append("\(pricehistory)")

                }

            }
<<<<<<< HEAD
            FooterButtons(in_search: false)
=======
            data = storage
>>>>>>> proto
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
    
}

struct ProductView_Previews: PreviewProvider {
    static var previews: some View {
        ProductView()
    }
}

