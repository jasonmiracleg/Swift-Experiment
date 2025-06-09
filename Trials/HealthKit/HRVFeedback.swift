//
//  HRVFeedback.swift
//  Trials
//
//  Created by Jason Miracle Gunawan on 09/06/25.
//

import HealthKit
import SwiftUI

class HealthManager: ObservableObject {
    private let healthStore = HKHealthStore()

    @Published var heartRate: Double = 0
    @Published var hrv: Double = 0
    @Published var stressStatus: String = "Unknown"

    func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else { return }

        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        let hrvType = HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!

        healthStore.requestAuthorization(toShare: [],
                                         read: [heartRateType, hrvType]) { success, error in
            if success {
                print("Authorization granted")
                DispatchQueue.main.async {
                    self.fetchHeartRateAndHRV()
                }
            } else {
                print("Authorization failed: \(String(describing: error))")
            }
        }
    }

    func fetchHeartRateAndHRV() {
        fetchLatestHeartRate { heartRate in
            DispatchQueue.main.async {
                self.heartRate = heartRate
                self.updateStressStatus()
            }
        }

        fetchLatestHRV { hrv in
            DispatchQueue.main.async {
                self.hrv = hrv
                self.updateStressStatus()
            }
        }
    }

    private func fetchLatestHeartRate(completion: @escaping (Double) -> Void) {
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else { return }

        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)

        let query = HKSampleQuery(sampleType: heartRateType,
                                  predicate: nil,
                                  limit: 1,
                                  sortDescriptors: [sortDescriptor]) { query, results, error in
            guard let sample = results?.first as? HKQuantitySample else {
                print("No HR sample")
                completion(0)
                return
            }

            let bpm = sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
            completion(bpm)
        }

        healthStore.execute(query)
    }

    private func fetchLatestHRV(completion: @escaping (Double) -> Void) {
        guard let hrvType = HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN) else { return }

        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)

        let query = HKSampleQuery(sampleType: hrvType,
                                  predicate: nil,
                                  limit: 1,
                                  sortDescriptors: [sortDescriptor]) { query, results, error in
            guard let sample = results?.first as? HKQuantitySample else {
                print("No HRV sample")
                completion(0)
                return
            }

            let ms = sample.quantity.doubleValue(for: HKUnit.secondUnit(with: .milli))
            completion(ms)
        }

        healthStore.execute(query)
    }

    private func updateStressStatus() {
        if heartRate > 90 && hrv < 30 {
            stressStatus = "⚠️ Stressed"
        } else if heartRate < 75 && hrv > 50 {
            stressStatus = "✅ Relaxed"
        } else {
            stressStatus = "🟡 Neutral"
        }
    }
}

struct HRVFeedback: View {
    @StateObject var healthManager = HealthManager()

    var body: some View {
        VStack(spacing: 20) {
            Text("Heart Rate: \(healthManager.heartRate, specifier: "%.1f") BPM")
            Text("HRV (SDNN): \(healthManager.hrv, specifier: "%.1f") ms")
            Text("Status: \(healthManager.stressStatus)")
                .font(.largeTitle)

            Button("Refresh") {
                healthManager.fetchHeartRateAndHRV()
            }
        }
        .padding()
        .onAppear {
            healthManager.requestAuthorization()
        }
    }
}
