# coding: utf-8

"""
    Simple Inventory API

    This is a simple API

    OpenAPI spec version: 1.0.0
    Contact: you@your-company.com
    Generated by: https://github.com/swagger-api/swagger-codegen.git

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
"""

from __future__ import absolute_import

# import models into sdk package
from .models.inventory_item import InventoryItem
from .models.manufacturer import Manufacturer

# import apis into sdk package
from .apis.admins_api import AdminsApi
from .apis.developers_api import DevelopersApi

# import ApiClient
from .api_client import ApiClient

from .configuration import Configuration

configuration = Configuration()
