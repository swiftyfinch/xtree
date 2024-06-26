import Rainbow

extension RainbowNamespace {
    func split() -> String {
        let entry = Rainbow.extractEntry(for: string)
        var segments: [Rainbow.Segment] = []
        for segment in entry.segments {
            for character in segment.text.raw {
                let characterSegment = Rainbow.Segment(text: String(character),
                                                       color: segment.color,
                                                       backgroundColor: segment.backgroundColor,
                                                       styles: segment.styles)
                segments.append(characterSegment)
            }
        }
        let splittedEntry = Rainbow.Entry(segments: segments)
        return Rainbow.generateString(for: splittedEntry)
    }
}
