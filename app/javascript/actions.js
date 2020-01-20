/* global App */
import logger from 'logger';

const fetchRessource = function(path) {
  return fetch(path).then(response => response.json());
};

export default {
  updateSaveGame(passage) {
    console.debug('[NotImplemented] updateSaveGame', passage);
  },
  fetchSaveGames: function() {
    return fetchRessource('/save_games.json');
  },
  fetchMessages: function() {
    return fetchRessource('/messages.json');
  },
  fetchActiveGame: function() {
    return fetchRessource('/save_games/active.json');
  },
  fetchPassage: function(active) {
    console.debug(active);
    const id = active['passage_id']['$oid'];
    const story = active['story_id']['$oid'];

    return fetchRessource(`/stories/${story}/passages/${id}.json`);
  },
  subscribeForMessages: function(callback) {
    logger.debug('Subscribe for messages');

    App.cable.subscriptions.create('MessagesChannel', {
      connected: () => logger.debug('Messages stream connected'),
      disconnected: () => logger.debug('Messages stream disconnected'),
      received: callback,
    });
  },
};
