import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

Uint8List createWav(List<double> samples, int sampleRate) {
  final int byteLength = samples.length * 2;
  final ByteData byteData = ByteData(44 + byteLength);

  // 'RIFF'
  byteData.setUint8(0, 0x52);
  byteData.setUint8(1, 0x49);
  byteData.setUint8(2, 0x46);
  byteData.setUint8(3, 0x46);
  byteData.setUint32(4, 36 + byteLength, Endian.little);

  // 'WAVE'
  byteData.setUint8(8, 0x57);
  byteData.setUint8(9, 0x41);
  byteData.setUint8(10, 0x56);
  byteData.setUint8(11, 0x45);

  // 'fmt '
  byteData.setUint8(12, 0x66);
  byteData.setUint8(13, 0x6D);
  byteData.setUint8(14, 0x74);
  byteData.setUint8(15, 0x20);
  byteData.setUint32(16, 16, Endian.little); // Subchunk1Size
  byteData.setUint16(20, 1, Endian.little); // AudioFormat PCM = 1
  byteData.setUint16(22, 1, Endian.little); // NumChannels = 1
  byteData.setUint32(24, sampleRate, Endian.little); // SampleRate
  byteData.setUint32(28, sampleRate * 2, Endian.little); // ByteRate = SampleRate * NumChannels * BitsPerSample/8
  byteData.setUint16(32, 2, Endian.little); // BlockAlign = NumChannels * BitsPerSample/8
  byteData.setUint16(34, 16, Endian.little); // BitsPerSample = 16

  // 'data'
  byteData.setUint8(36, 0x64);
  byteData.setUint8(37, 0x61);
  byteData.setUint8(38, 0x74);
  byteData.setUint8(39, 0x61);
  byteData.setUint32(40, byteLength, Endian.little);

  // Samples
  for (int i = 0; i < samples.length; i++) {
    final double s = samples[i].clamp(-1.0, 1.0);
    final int sampleInt = (s * 32767).toInt();
    byteData.setInt16(44 + i * 2, sampleInt, Endian.little);
  }

  return byteData.buffer.asUint8List();
}

List<double> generateTone(double freq, double durationSec, int sampleRate, double maxAmp) {
  final int count = (durationSec * sampleRate).toInt();
  final List<double> samples = List<double>.filled(count, 0.0);
  final int attack = (0.01 * sampleRate).toInt();
  final int release = (0.02 * sampleRate).toInt();

  for (int i = 0; i < count; i++) {
    final double t = i / sampleRate;
    double env = 1.0;
    if (i < attack) {
      env = i / attack;
    } else if (i > count - release) {
      env = (count - i) / release;
    }
    samples[i] = math.sin(2 * math.pi * freq * t) * maxAmp * env;
  }
  return samples;
}

void main() {
  const int sampleRate = 44100;

  // 1. listening-start: rising tone C5 (523Hz) -> E5 (659Hz), total ~120ms
  final List<double> start1 = generateTone(523.25, 0.055, sampleRate, 0.7);
  final List<double> start2 = generateTone(659.25, 0.065, sampleRate, 0.75);
  final List<double> startAll = <double>[...start1, ...start2];
  File('assets/audio/listening_start.wav')
      .writeAsBytesSync(createWav(startAll, sampleRate));

  // 2. listening-end: falling tone E5 (659Hz) -> A4 (440Hz), total ~120ms
  final List<double> end1 = generateTone(659.25, 0.055, sampleRate, 0.7);
  final List<double> end2 = generateTone(440.00, 0.065, sampleRate, 0.65);
  final List<double> endAll = <double>[...end1, ...end2];
  File('assets/audio/listening_end.wav')
      .writeAsBytesSync(createWav(endAll, sampleRate));

  // 3. assistant-error: gentle alert tone F#4 (370Hz) -> D4 (294Hz), total ~160ms
  final List<double> err1 = generateTone(369.99, 0.075, sampleRate, 0.65);
  final List<double> err2 = generateTone(293.66, 0.085, sampleRate, 0.6);
  final List<double> errAll = <double>[...err1, ...err2];
  File('assets/audio/assistant_error.wav')
      .writeAsBytesSync(createWav(errAll, sampleRate));

  print('Audio files generated successfully!');
}
