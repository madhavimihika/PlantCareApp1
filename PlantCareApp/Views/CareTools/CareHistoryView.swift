import SwiftUI

struct CareHistoryView: View {
    @StateObject private var viewModel = MyPlantsViewModel.shared
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.plantBackground.ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("MY PLANT CARE").font(.caption).fontWeight(.bold).foregroundColor(.gray)
                            Text("Care History").font(.system(size: 34, weight: .bold, design: .serif)).foregroundColor(.plantText)
                        }
                        
                        if viewModel.history.isEmpty {
                            Text("No activity yet. Water a plant to see history!").font(.subheadline).foregroundColor(.gray)
                                .padding(.top, 20)
                        } else {
                            VStack(spacing: 15) {
                                ForEach(viewModel.history) { item in
                                    HStack(alignment: .top, spacing: 15) {
                                        Image(systemName: item.icon)
                                            .font(.title3).foregroundColor(item.color)
                                            .frame(width: 40, height: 40).background(item.color.opacity(0.15)).clipShape(Circle())
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(item.action).font(.headline).foregroundColor(.plantText)
                                            Text(item.plantName).font(.subheadline).foregroundColor(.gray)
                                        }
                                        Spacer()
                                        Text(item.date).font(.caption).foregroundColor(.gray)
                                    }
                                    .padding().background(Color.white).clipShape(RoundedRectangle(cornerRadius: 15))
                                }
                            }
                        }
                    }.padding(20)
                }
            }.navigationBarHidden(true)
        }
    }
}
//already added in MyPlantsViewModel