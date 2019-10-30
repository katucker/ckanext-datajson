import copy

from nose.tools import assert_equal, assert_raises, assert_in
import json
from mock import patch, MagicMock, Mock
from requests.exceptions import HTTPError, RequestException

try:
    from ckan.tests.helpers import reset_db, call_action
    from ckan.tests.factories import Organization, Group
except ImportError:
    from ckan.new_tests.helpers import reset_db, call_action
    from ckan.new_tests.factories import Organization, Group
from ckan import model
from ckan.plugins import toolkit

# from ckanext.harvest.tests.factories import (HarvestSourceObj, HarvestJobObj,
#                                              HarvestObjectObj)
from factories import (HarvestSourceObj,
                       HarvestJobObj,
                       HarvestObjectObj)

import ckanext.harvest.model as harvest_model
from ckanext.harvest.harvesters.base import HarvesterBase
from ckanext.datajson.harvester_datajson import DataJsonHarvester
import logging
log = logging.getLogger("harvester")

import mock_datajson_source

# Start data json sources server we can test harvesting against it
mock_datajson_source.serve()


class TestDataJSONHarvester(object):
    @classmethod
    def setup(cls):
        reset_db()
        harvest_model.setup()

    def run_source(self, url):
        source = HarvestSourceObj(url=url)
        job = HarvestJobObj(source=source)

        harvester = DataJsonHarvester()

        # gather stage
        log.info('GATHERING %s', url)
        obj_ids = harvester.gather_stage(job)
        log.info('job.gather_errors=%s', job.gather_errors)
        log.info('obj_ids=%s', obj_ids)
        if len(obj_ids) == 0:
            # nothing to see
            return

        harvest_object = harvest_model.HarvestObject.get(obj_ids[0])
        log.info('ho guid=%s', harvest_object.guid)
        log.info('ho content=%s', harvest_object.content)

        # fetch stage
        log.info('FETCHING %s', url)
        result = harvester.fetch_stage(harvest_object)

        log.info('ho errors=%s', harvest_object.errors)
        log.info('result 1=%s', result)

        # fetch stage
        log.info('IMPORTING %s', url)
        result = harvester.import_stage(harvest_object)

        log.info('ho errors 2=%s', harvest_object.errors)
        log.info('result 2=%s', result)
        log.info('ho pkg id=%s', harvest_object.package_id)
        dataset = model.Package.get(harvest_object.package_id)
        log.info('dataset name=%s', dataset.name)

    def test_datason_usda(self):
        url = 'https://www.archive.arm.gov/metadata/data.json'
        self.run_source(url=url)
    
    def test_datason_arm(self):
        url = 'http://www.usda.gov/data.json'
        self.run_source(url=url)
    
    def test_datason_404(self):
        url = 'http://some404/data.json'
        with assert_raises(URLError) as harvest_context:
            self.run_source(url=url)
        
    def test_datason_500(self):
        url = 'http://some500/data.json'
        with assert_raises(URLError) as harvest_context:
            self.run_source(url=url)