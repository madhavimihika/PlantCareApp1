import SwiftUI

struct OnboardingPage: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let desc: String
}

struct OnboardingView: View {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    @Binding var isAuthenticated: Bool

    @State private var page = 0

    private let pages = [
        OnboardingPage(icon: "drop.fill",
                       title: "Smart watering",
                       desc: "Get a reminder when each plant is thirsty, so you never forget again."),
        OnboardingPage(icon: "camera.viewfinder",
                       title: "Disease scanner",
                       desc: "Scan a leaf and find out what's wrong in seconds."),
        OnboardingPage(icon: "chart.line.uptrend.xyaxis",
                       title: "Growth tracking",
                       desc: "Add photos over time and watch your plants grow.")
    ]

    private var isLast: Bool { page == pages.count - 1 }

    var body: some View {
        ZStack {
            Color.plantBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                skipButton

                TabView(selection: $page) {
                    ForEach(Array(pages.enumerated()), id: \.element.id) { index, item in
                        OnboardingPageView(page: item)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                dots
                    .padding(.bottom, 24)

                nextButton
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
            }
        }
    }

    // MARK: - Pieces

    private var skipButton: some View {
        HStack {
            Spacer()
            Button("Skip") { finish() }
                .font(.subheadline.weight(.medium))
                .foregroundColor(.secondary)
                .opacity(isLast ? 0 : 1)
                .disabled(isLast)
        }
        .padding(.horizontal, 24)
        .padding(.top, 12)
        .frame(height: 44)
    }

    private var dots: some View {
        HStack(spacing: 8) {
            ForEach(0..<pages.count, id: \.self) { index in
                Capsule()
                    .fill(index == page ? Color.plantPrimary : Color.plantPrimary.opacity(0.25))
                    .frame(width: index == page ? 24 : 8, height: 8)
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: page)
    }

    private var nextButton: some View {
        Button {
            if isLast {
                finish()
            } else {
                withAnimation(.easeInOut) { page += 1 }
            }
        } label: {
            Text(isLast ? "Get started" : "Next")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(Color.plantPrimary)
                )
                .shadow(color: Color.plantPrimary.opacity(0.3), radius: 10, y: 5)
        }
    }

    private func finish() {
        hasSeenOnboarding = true // saved on the phone
    }
}

// MARK: - One page

struct OnboardingPageView: View {
    let page: OnboardingPage

    var body: some View {
        VStack(spacing: 36) {
            Spacer()

            ZStack {
                Circle()
                    .fill(Color.plantPrimary.opacity(0.08))
                    .frame(width: 260, height: 260)
                Circle()
                    .fill(Color.plantPrimary.opacity(0.14))
                    .frame(width: 200, height: 200)
                Circle()
                    .fill(Color.white)
                    .frame(width: 140, height: 140)
                    .shadow(color: Color.plantPrimary.opacity(0.2), radius: 16, y: 8)
                Image(systemName: page.icon)
                    .font(.system(size: 56, weight: .semibold))
                    .foregroundColor(.plantPrimary)
            }

            VStack(spacing: 12) {
                Text(page.title)
                    .font(.system(.title, design: .rounded).weight(.bold))
                    .foregroundColor(.plantText)
                    .multilineTextAlignment(.center)

                Text(page.desc)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 36)
            }

            Spacer()
            Spacer()
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(isAuthenticated: .constant(false))
    }
}