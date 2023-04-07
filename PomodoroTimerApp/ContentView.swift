//
//  ContentView.swift
//  PomodoroTimerApp
//
//  Created by Yauheni Suhakou on 07.04.23.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State var remainingTime = 25 * 60 // 25 minutes in seconds
    @State var isTimerRunning = false
    @State var player: AVAudioPlayer?
    @State var timer: Timer?

    var body: some View {
        VStack {
            Text("\(remainingTime / 60) : \(String(format: "%02d", remainingTime % 60))")
                .font(.system(size: 70, weight: .thin))
                .foregroundColor(Color.blue)

            if isTimerRunning {
                Button(action: {
                    stopTimer()
                }) {
                    Text("Stop")
                }
            } else {
                Button(action: {
                    startTimer()
                }) {
                    Text("Start")
                }
            }
        }
        .padding(.top, 50)
        .onAppear {
            loadSound()
        }
    }

    func startTimer() {
        isTimerRunning = true
        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            onTick()
        }
        RunLoop.current.add(timer, forMode: .common)
    }

    func stopTimer() {
        isTimerRunning = false
        timer?.invalidate()
        timer = nil
    }

    func onTick() {
        if remainingTime > 0 {
            remainingTime -= 1
            if remainingTime == 0 {
                player?.play()
                stopTimer()
            }
        }
    }

    func loadSound() {
        guard let url = Bundle.main.url(forResource: "Ping", withExtension: "aiff") else {
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
        } catch {
            print("Could not load beep sound file")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
