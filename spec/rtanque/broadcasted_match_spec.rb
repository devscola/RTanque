require "spec_helper"

describe RTanque::BroadcastedMatch do

  it 'proxies almost all method calls to given match' do
    match = spy('match')
    broadcaster = double('broadcaster')

    broadcasted_match = described_class.new match, broadcaster
    broadcasted_match.finished?

    expect(match).to have_received(:finished?)
  end

  it 'does not delegate start' do
    match = spy('match')
    broadcaster = spy('broadcaster')

    broadcasted_match = described_class.new match, broadcaster
    broadcasted_match.start

    expect(match).not_to have_received(:start)
  end

  it 'also calls broadcaster transmit on tick' do
    match = spy('match')
    broadcaster = spy('broadcaster')

    broadcasted_match = described_class.new match, broadcaster
    broadcasted_match.tick

    expect(match).to have_received(:tick)
    expect(broadcaster).to have_received(:transmit)
  end

  it 'transmitted message is a serialization of current match snapshot' do
    match_status = {game: :status}
    match_ticks = 3

    broadcaster = spy('broadcaster')
    match = double('match', ticks: match_ticks, to_h: match_status)
    allow(match).to receive(:tick)

    broadcasted_match = described_class.new match, broadcaster
    broadcasted_match.tick

    expect(broadcaster).to have_received(:transmit).with({
      tick: match_ticks,
      scene: match_status
    }.to_json)
  end
end
