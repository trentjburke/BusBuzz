import SwiftUI

struct BusOperatorTimetableScreen: View {
    var timetableData: [BusTimetable] = [
        BusTimetable(routeNumber: "119", direction: "Maharagama to Dehiwala", time: "5:00 AM", status: "Completed", date: "24th March 2025"),
        BusTimetable(routeNumber: "119", direction: "Dehiwala to Maharagama", time: "8:30 AM", status: "In Progress", date: "24th March 2025"),
        BusTimetable(routeNumber: "119", direction: "Maharagama to Dehiwala", time: "11:00 AM", status: "Scheduled", date: "24th March 2025"),
        BusTimetable(routeNumber: "119", direction: "Dehiwala to Maharagama", time: "1:30 PM", status: "Scheduled", date: "24th March 2025"),
        BusTimetable(routeNumber: "119", direction: "Maharagama to Dehiwala", time: "3:00 PM", status: "Scheduled", date: "24th March 2025"),
        BusTimetable(routeNumber: "119", direction: "Dehiwala to Maharagama", time: "5:00 PM", status: "Scheduled", date: "24th March 2025"),
        BusTimetable(routeNumber: "119", direction: "Maharagama to Dehiwala", time: "7:30 PM", status: "Scheduled", date: "24th March 2025"),
        BusTimetable(routeNumber: "119", direction: "Dehiwala to Maharagama", time: "9:00 PM", status: "Scheduled", date: "24th March 2025")
    ]
    
    var body: some View {
        ZStack {
            AppColors.background.edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Bus Timetable")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(.top, 10)
                
                Text(timetableData.first?.date ?? "")
                    .font(.headline)
                    .foregroundColor(AppColors.buttonGreen)
                    .padding(.top, 5)

                
                ScrollView {
                    ForEach(timetableData) { timetable in
                        BusTimetableCard(timetable: timetable)
                            .padding(.horizontal)
                            .padding(.bottom, 2)
                    }
                }

                Spacer()
            }
            .overlay(
                VStack {
                    Spacer()
                    AppColors.grayBackground
                        .frame(height: 83)
                        .edgesIgnoringSafeArea(.bottom)
                }
                .edgesIgnoringSafeArea(.bottom)
            )
        }
    }
}

struct BusTimetableCard: View {
    var timetable: BusTimetable
    
    var body: some View {
        VStack(spacing: 2) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("\(timetable.routeNumber) - \(timetable.direction)")
                        .font(.subheadline)
                        .foregroundColor(AppColors.background)
                        .lineLimit(1)
                    
                    Text("Scheduled time: \(timetable.time)")
                        .font(.caption)
                        .foregroundColor(AppColors.background)
                        .lineLimit(1)
                }
                
                Spacer()

                // Status Text and Dot Indicator
                HStack(spacing: 8) {
                    Text(statusText(for: timetable.status))
                        .font(.caption)
                        .foregroundColor(statusColor(for: timetable.status))
                    
                    // Dot Indicator
                    Circle()
                        .fill(statusColor(for: timetable.status))
                        .frame(width: 12, height: 12)
                }
            }
            .padding(8)
            .background(RoundedRectangle(cornerRadius: 12).fill(AppColors.grayBackground))
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 2)
    }
    
    
    func statusText(for status: String) -> String {
        switch status {
        case "Completed":
            return "Completed"
        case "In Progress":
            return "In Progress"
        case "Scheduled":
            return "Scheduled"
        default:
            return ""
        }
    }
    

    func statusColor(for status: String) -> Color {
        switch status {
        case "Completed":
            return Color.red
        case "In Progress":
            return Color.green
        case "Scheduled":
            return Color.yellow
        default:
            return Color.gray
        }
    }
}

struct BusTimetable: Identifiable {
    let id = UUID()
    var routeNumber: String
    var direction: String
    var time: String
    var status: String
    var date: String
}

struct BusOperatorTimetableScreen_Previews: PreviewProvider {
    static var previews: some View {
        BusOperatorTimetableScreen()
    }
}
