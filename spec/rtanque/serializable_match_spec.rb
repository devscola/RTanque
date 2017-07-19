require "spec_helper"

describe RTanque::SerializableMatch do

  it 'proxies all method calls to given match' do
    match = spy('match')

    broadcasted_match = described_class.new match

    broadcasted_match.finished?
    expect(match).to have_received(:finished?)


    broadcasted_match.start
    expect(match).to have_received(:start)
  end

  it 'adds snapshot method which serializes current match status' do
    match_status = {game: :status}
    match_ticks = 3

    match = double('match', ticks: match_ticks, to_h: match_status)
    broadcasted_match = described_class.new match

    expect(broadcasted_match.snapshot).to eq({
      tick: match_ticks,
      scene: match_status
    })
  end
end
