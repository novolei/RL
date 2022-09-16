import SwiftUI

struct CenterView: View {
    @State var activeView: currentView
    
    var body: some View {
        GeometryReader { bounds in
            VStack(spacing: 10) {
               
                ScrollView(showsIndicators: false) {
                    VStack{
                        Text("Center")
                            .fontWeight(.light)
                            .foregroundColor(.white.opacity(0.95))
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 320, height: 320)
                        .foregroundColor(.green)
                        
                        ForEach(1 ..< 100 ,id:\.self) { id in
                            Text(String(id))
                                .fontWeight(.light)
                                .foregroundColor(.white.opacity(0.95))
                                .padding(10)
                            
                        }
                    }
                    
                    .frame(width: bounds.size.width)
                    .padding(.bottom, 80)
                }
               
                
//                .background(Color.red)
               
            }
           
            .frame(width: bounds.size.width, height: bounds.size.height, alignment: .top)
//            .background(Color.gray)
            .padding(.top, 40)
//            .padding(.horizontal, 2)
           
        }
//        .background(Color.blue)
       
//        .cornerRadius(20)
//        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
}

struct CenterView_Previews: PreviewProvider {
    static var previews: some View {
        CenterView(activeView: .center)
    }
}
